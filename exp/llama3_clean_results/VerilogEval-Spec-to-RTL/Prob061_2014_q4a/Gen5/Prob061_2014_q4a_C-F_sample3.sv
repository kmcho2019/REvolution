module TopModule(
    input clk,  // Clock signal
    input w,    // Input from the previous stage
    input R,    // Value to load
    input E,    // Enable shift
    input L,    // Load signal
    output reg Q  // Output of the module
);

always @(posedge clk)
    Q <= (L)? R : (E)? w : Q;

endmodule