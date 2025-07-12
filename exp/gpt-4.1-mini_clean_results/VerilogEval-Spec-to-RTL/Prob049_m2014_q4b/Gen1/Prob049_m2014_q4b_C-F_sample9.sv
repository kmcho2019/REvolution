module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Positive edge-triggered D flip-flop with asynchronous active-high reset.
// When 'ar' is asserted (high), output 'q' is immediately reset to 0,
// regardless of the clock. Otherwise, 'q' captures 'd' on clk rising edge.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule