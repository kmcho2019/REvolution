module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Positive-edge triggered D flip-flop with asynchronous active-high reset (ar).
// When ar is asserted, q is immediately reset to 0 independent of clk.
// Otherwise, on the rising edge of clk, q captures the input d.
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule