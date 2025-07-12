module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

// Initialize the counter to 0, leveraging the default initialization
// behavior of Verilog for reg types.
initial q = 4'd0;

// Maintain simplicity and efficiency by directly incrementing the counter
// unless reset is high, leveraging the natural wrap-around of binary arithmetic.
always @(posedge clk)
    if (reset) q <= 4'd0; // Synchronous reset to 0
    else q <= q + 1;

endmodule