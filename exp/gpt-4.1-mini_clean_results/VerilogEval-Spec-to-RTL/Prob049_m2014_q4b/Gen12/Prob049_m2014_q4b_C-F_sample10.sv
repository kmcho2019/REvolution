module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

// Initialize q to zero at simulation start for known state
initial q = 1'b0;

// Positive-edge triggered D flip-flop with asynchronous reset using non-blocking assignments
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0; // async reset asserted: clear q
    else
        q <= d;    // capture data on clock edge
end

endmodule