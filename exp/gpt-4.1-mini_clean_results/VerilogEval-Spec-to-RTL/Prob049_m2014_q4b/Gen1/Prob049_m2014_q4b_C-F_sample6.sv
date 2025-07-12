module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous reset (active high).
// When 'ar' is asserted, 'q' is asynchronously reset to 0.
// Otherwise, 'q' samples 'd' at the rising edge of 'clk'.
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d;
end

endmodule