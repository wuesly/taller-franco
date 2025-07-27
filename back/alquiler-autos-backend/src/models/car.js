import mongoose from "mongoose";

const carSchema = new mongoose.Schema({
  brand: String,
  model: String,
  available: { type: Boolean, default: true },
  rentedBy: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null }
});

export default mongoose.model("Car", carSchema);
