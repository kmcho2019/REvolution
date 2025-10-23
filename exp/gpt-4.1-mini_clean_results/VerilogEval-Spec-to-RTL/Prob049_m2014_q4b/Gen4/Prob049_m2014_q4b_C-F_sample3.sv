module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Positive edge-triggered D flip-flop with asynchronous active-high reset.
// 'q' asynchronously resets to 0 when 'ar' is high.
// Otherwise, 'q' captures 'd' on the rising edge of 'clk'.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule