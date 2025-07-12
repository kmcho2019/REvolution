module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Initialize q to zero at simulation start for known state (synthesis tools usually ignore)
initial q = 1'b0;

// Positive-edge triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;
    else     q <= d;

endmodule