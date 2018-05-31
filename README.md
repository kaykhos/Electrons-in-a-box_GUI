# Electrons-in-a-box_GUI
 N-body electron simulation of electrons on different shape conductors (solves the equilibrium distribution) 

## REQUIRES MATLAB 8 OR LATER TO RUN!

Solves for the electron distribution on different highly symmetric shapes, in 1, 2, and 3D. Matlab GUI to choose shape and numerical solver parameters. Uses a highly damped ODE to let electrons propagate to equilibrium position while the damping removes excess potential energy above the equilibrium value. User has access to final electron position from which to calculate electrostatic potential, Electric field vector, capacitance etc. 

Run Controler.m, all other files are aux functions/scripts. 
## GUI options:
Continue:   Keep results from previous propagation step

Plot:       Plot solution as it's solving or now (uncheck for speed)

Stop:      Stop current simulation (keep solution up until that point)

Start:      Begin running the ODE solver

Object:     Select geometric shape to put electrons on

Dim:       Set the number of dimensions of the geometric shape

L,W,H:     Defines length, width, height (or Radius) of geometric shape)

#e:         Total number of electrons in the simulation

Steps:      Number of time steps to run the time propagation for

/beta:      Dimensionless parameter that defines the energy damping rate (increase for more damping decrease for less damping)

dt:         Time step for solver propagation

## Important variables: 
rMat:       Current location of each electron
