// TopModule: Always drives output 'one' high, refactored structure using initial block.
module TopModule(
    output reg one // Declare 'one' as a reg to allow assignment in initial block
);

// Use an initial block to set the output 'one' to 1 at the start of the simulation.
initial one = 1'b1;

endmodule