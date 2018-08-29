# flowfield
A flowfield created in Processing.  

Basically grid of (invisible) points that each generate a 3d noise value.  The first two values for each point's noise value comes from its own x and y coordinate.  The third value for the noise function is a global z value that slowly increments.  

Then, a bunch of particles are dropped in that flow according to the direction of the closest point's noise value.  As they move, they each draw a line.  Eventually, you get a cool effect.
