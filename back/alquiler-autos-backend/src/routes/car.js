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
    console.error("ERROR POST /cars ->", err);
    res.status(400).json({ message: "Error al crear vehículo", details: err.message });
  }
});

// Ver todos los vehículos
router.get("/", async (req, res) => {
  try {
    const cars = await Car.find();
    res.json(cars);
  } catch (err) {
    console.error("ERROR GET /cars ->", err);
    res.status(500).json({ message: "Error al obtener vehículos", details: err.message });
  }
});

// Actualizar vehículo
router.put("/:id", async (req, res) => {
  try {
    const updatedCar = await Car.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updatedCar) return res.status(404).json({ message: "Vehículo no encontrado" });
    res.json(updatedCar);
  } catch (err) {
    console.error("ERROR PUT /cars/:id ->", err);
    res.status(500).json({ message: "Error al actualizar vehículo", details: err.message });
  }
});

// Eliminar vehículo
router.delete("/:id", async (req, res) => {
  try {
    const deletedCar = await Car.findByIdAndDelete(req.params.id);
    if (!deletedCar) return res.status(404).json({ message: "Vehículo no encontrado" });
    res.json({ message: "Vehículo eliminado" });
  } catch (err) {
    console.error("ERROR DELETE /cars/:id ->", err);
    res.status(500).json({ message: "Error al eliminar vehículo", details: err.message });
  }
});

// Alquilar vehículo
router.post("/:id/rent", async (req, res) => {
  try {
    const car = await Car.findById(req.params.id);
    if (!car) return res.status(404).json({ message: "Vehículo no encontrado" });

    if (!car.available) return res.status(400).json({ message: "Vehículo no disponible" });

    // Actualizamos el vehículo como alquilado
    car.available = false;
    car.rentedBy = req.body.userId || null;
    await car.save();

    res.status(200).json({ message: "Vehículo alquilado con éxito", car });
  } catch (err) {
    console.error("ERROR POST /cars/:id/rent ->", err);
    res.status(500).json({ message: "Error al alquilar vehículo", details: err.message });
  }
});

export default router;
