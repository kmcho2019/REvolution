module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Combinational mux for asynchronous reset effect
wire d_or_reset = ar ? 1'b0 : d;

// Positive-edge triggered D flip-flop without async reset
always @(posedge clk) begin
    q <= d_or_reset;
end

endmodule