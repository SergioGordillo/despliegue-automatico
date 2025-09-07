import { envConstants } from "#core/index.js";
import { MongoClient } from "mongodb";

export const run = async () => {
  if (!envConstants.MONGODB_URI) {
    throw new Error("MONGODB_URI is not defined");
  }

  console.log("DEBUG: MONGODB_URI_ATLAS1 =", envConstants.MONGODB_URI_ATLAS);

  if (!envConstants.MONGODB_URI_ATLAS) {
    throw new Error("MONGODB_URI_ATLAS is not defined");
  }

  const clientLocal = new MongoClient(envConstants.MONGODB_URI);
  await clientLocal.connect();
  const dbLocal = clientLocal.db("airbnb");
  const collectionLocal = dbLocal.collection("listingsAndReviews");

  const documents = await collectionLocal.find({}).toArray();
  console.log(`There are ${documents.length} documents in local DB`);

  console.log("DEBUG: MONGODB_URI_ATLAS2 =", envConstants.MONGODB_URI_ATLAS);

  const clientAtlas = new MongoClient(envConstants.MONGODB_URI_ATLAS);
  await clientAtlas.connect();
  const dbAtlas = clientAtlas.db("airbnb");
  const collectionAtlas = dbAtlas.collection("listingsAndReviews");

  if (documents.length > 0) {
    const result = await collectionAtlas.insertMany(documents);
    console.log(
      `✅ ${result.insertedCount} documents have been inserted in Mongo Atlas`
    );
  } else {
    console.log("⚠️ There are no documents to insert");
  }

  await clientLocal.close();
  await clientAtlas.close();
};

run().catch((err) => {
  console.error("❌ Error while execution of seed runner:", err);
});
