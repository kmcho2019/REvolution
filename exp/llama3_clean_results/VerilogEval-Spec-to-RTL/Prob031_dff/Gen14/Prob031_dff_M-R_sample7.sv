module TopModule(
    input clk,
    input d,
    output reg q = 0 // Initialize q directly in its declaration
);

// Use a non-blocking assignment to update the flip-flop's state on the positive edge of the clock
always @(posedge clk)
    q <= d;

endmodule