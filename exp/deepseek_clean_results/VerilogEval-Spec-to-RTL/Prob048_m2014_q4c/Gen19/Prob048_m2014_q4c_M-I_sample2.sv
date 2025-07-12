module TopModule (
    input  clk,
    input  d,
    input  r,    // Synchronous reset (active high)
    output reg q
);

// D flip-flop with synchronous reset to 0
always @(posedge clk)
    q <= r ? 1'b0 : d;

endmodule