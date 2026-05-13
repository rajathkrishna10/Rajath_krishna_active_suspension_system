
# Rajath_krishna_active_suspension_system

---


## Overview
This project focuses on designing an Active Suspension Control System to reduce vehicle vibrations caused by road disturbances such as bumps and uneven roads.

The system uses a PID controller to improve damping behavior, reduce oscillations, and achieve better ride comfort.

---

## Objectives

- Minimize oscillations
- Improve damping characteristics
- Reduce settling time
- Improve passenger comfort
- Compare controlled and uncontrolled response

##  Working Principle

1. The suspension system receives disturbance from road bumps.
2. The uncontrolled system produces oscillations and slower settling response.
3. A PID controller is introduced to improve system performance.
4. The controller continuously adjusts the control force based on system error.
5. The controlled system achieves:
   - Reduced oscillations
   - Faster settling time
   - Improved damping behavior
   - Better ride comfort

The system response is analyzed using MATLAB simulations and comparison graphs.

---

## System Description

The suspension system is modeled using the transfer function:

G(s) = 1 / (s² + 3s + 2)

Where:
- Input → Control Force
- Output → Body Displacement
- Disturbance → Road Bump

---

## Controller Used

PID (Proportional–Integral–Derivative) Controller

The controller improves:
- Stability
- Damping
- Settling time
- Ride comfort

---

## Tools & Technologies

- MATLAB
- Simulink
- Control System Design
- PID Controller

---

##  Simulation Results

 Uncontrolled Suspension Response
Shows oscillatory behavior and slower settling time.

 PID Controlled Suspension Response
Shows improved damping and reduced oscillations.

 Comparison Graph
Comparison between uncontrolled and PID-controlled suspension responses demonstrating improved stability and ride comfort.

---

## Expected Outcomes

- Reduced vibrations  
- Faster settling time  
- Improved damping  
- Better suspension stability  
- Enhanced ride comfort  

---

##  Applications

- Smart vehicles
- Electric vehicles
- Autonomous cars
- Automotive suspension systems

---

##  Future Scope

- AI based adaptive suspension
- Real time sensor integration
- Smart road disturbance prediction

---

##  Hackathon Project

Developed as part of a Control Systems Hackathon Project.
