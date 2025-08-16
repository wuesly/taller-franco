import mongoose from "mongoose";

const carSchema = new mongoose.Schema({
  brand: String,
  model: String,
  available: { type: Boolean, default: true },
  rentedBy: { type: String, default: null } // <-- cambiar ObjectId por String
});

export default mongoose.model("Car", carSchema);
