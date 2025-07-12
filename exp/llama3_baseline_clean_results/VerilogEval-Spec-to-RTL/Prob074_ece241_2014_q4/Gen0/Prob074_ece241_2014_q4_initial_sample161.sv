module TopModule (
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;

always @(posedge clk) begin
    xor_ff_out <= x ^ xor_ff_out;
    and_ff_out <= x & ~and_ff_out;
    or_ff_out <= x | ~or_ff_out;
end

assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

initial begin
    xor_ff_out = 1'b0;
    and_ff_out = 1'b0;
    or_ff_out = 1'b0;
end

endmodule