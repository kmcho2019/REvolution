module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
) /* synthesis syn_preserve = 1 */ ; // Hint to preserve this module/flip-flop during optimization

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar)          // If asynchronous reset asserted, force q to 0 immediately
        q <= 1'b0;
    else             // Otherwise, sample input d on rising clock edge
        q <= d;
end

endmodule