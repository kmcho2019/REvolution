module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Explicit initial state to match simulation
);

always @(posedge clk) 
    q <= ~a; // Direct assignment for simplicity and efficiency

endmodule