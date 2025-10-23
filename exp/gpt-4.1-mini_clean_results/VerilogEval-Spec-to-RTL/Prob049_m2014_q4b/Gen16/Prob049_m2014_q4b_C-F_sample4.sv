module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
) /* synthesis syn_preserve = 1 */ ; // Hint to preserve the flip-flop during optimization

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;    // Async reset asserted: immediately clear q
    else
        q <= d;       // On clock rising edge, capture d
end

endmodule