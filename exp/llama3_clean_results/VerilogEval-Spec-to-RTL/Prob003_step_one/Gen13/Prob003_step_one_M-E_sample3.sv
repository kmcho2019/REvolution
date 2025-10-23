// TopModule: Alternative implementation using initial and always blocks.
module TopModule(
    output reg one
);

// Initialize the output 'one' to 1 at the start of the simulation.
initial one = 1'b1;

// Maintain the output 'one' at 1.
always @(*) one = 1'b1;

endmodule