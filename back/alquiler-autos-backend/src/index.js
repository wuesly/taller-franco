import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import authRoutes from "./routes/auth.js";
import carRoutes from "./routes/car.js";

dotenv.config();

const app = express();
const port = process.env.PORT || 9000;

// Middlewares
app.use(cors());
app.use(express.json());

// Rutas
app.use("/api/auth", authRoutes);
app.use("/api/cars", carRoutes);

// Conexión
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log("✅ Conectado a MongoDB Atlas"))
  .catch((err) => console.error("❌ Error de conexión:", err));

  app.listen(port, '0.0.0.0', () => console.log(`🚀 Servidor en puerto ${port}`));
