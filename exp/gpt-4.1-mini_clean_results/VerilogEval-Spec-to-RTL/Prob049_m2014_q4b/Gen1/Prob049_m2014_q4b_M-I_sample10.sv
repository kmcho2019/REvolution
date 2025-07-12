module TopModule (
    input  clk,
    input  ar,  // Asynchronous active-high reset
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous reset
// When 'ar' is asserted high, q is immediately reset to 0, independent of clk.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule