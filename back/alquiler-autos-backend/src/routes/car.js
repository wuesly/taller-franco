import express from "express";
import Car from "../models/car.js";

const router = express.Router();

// Crear vehículo
router.post("/", async (req, res) => {
  try {
    const car = new Car(req.body);
    await car.save();
    res.status(201).json(car);
  } catch (err) {
    res.status(400).json({ error: "Error al crear vehículo" });
  }
});

// Ver todos los vehículos
router.get("/", async (req, res) => {
  const cars = await Car.find();
  res.json(cars);
});

// Actualizar vehículo
router.put("/:id", async (req, res) => {
  await Car.findByIdAndUpdate(req.params.id, req.body);
  res.json({ message: "Vehículo actualizado" });
});

// Eliminar vehículo
router.delete("/:id", async (req, res) => {
  await Car.findByIdAndDelete(req.params.id);
  res.json({ message: "Vehículo eliminado" });
});

// Alquilar vehículo
router.post("/:id/rent", async (req, res) => {
  try {
    const car = await Car.findById(req.params.id);
    if (!car || !car.available)
      return res.status(400).json({ message: "Vehículo no disponible" });

    car.available = false;
    car.rentedBy = req.body.userId;
    await car.save();

    res.json({ message: "Vehículo alquilado con éxito" });
  } catch (err) {
    res.status(500).json({ error: "Error al alquilar" });
  }
});

export default router;
