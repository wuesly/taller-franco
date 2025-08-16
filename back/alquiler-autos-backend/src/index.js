import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import authRoutes from "./routes/auth.js";
import carRoutes from "./routes/car.js";

dotenv.config({ path: "../.env" });

const app = express();
const port = process.env.PORT || 9000;

// CORS abierto (para pruebas, funciona local y deploy)
app.use(cors({
  origin: '*',
  methods: ['GET','POST','PUT','DELETE','OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());

// Rutas
app.use("/api/auth", authRoutes);
app.use("/api/cars", carRoutes);

// Conexión a MongoDB
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log("✅ Conectado a MongoDB Atlas"))
  .catch((err) => console.error("❌ Error de conexión:", err));

app.listen(port, '0.0.0.0', () => console.log(`🚀 Servidor en puerto ${port}`));
