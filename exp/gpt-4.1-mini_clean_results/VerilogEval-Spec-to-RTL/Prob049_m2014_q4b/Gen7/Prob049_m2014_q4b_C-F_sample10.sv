module TopModule (
    input  clk,  // Clock input, positive edge triggered
    input  ar,   // Asynchronous active-high reset
    input  d,    // Data input
    output reg q // Data output (registered)
);

// Positive edge triggered D flip-flop with asynchronous active-high reset.
// When ar is asserted, q is immediately reset to 0 regardless of clock.
// Otherwise, q follows d on rising edge of clk.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule