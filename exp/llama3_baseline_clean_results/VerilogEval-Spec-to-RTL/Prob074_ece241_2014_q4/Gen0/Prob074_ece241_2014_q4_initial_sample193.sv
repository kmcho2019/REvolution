module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg xor_ff, and_ff, or_ff;

always @(posedge clk) begin
    xor_ff <= x ^ xor_ff;
    and_ff <= x & ~and_ff;
    or_ff <= x | ~or_ff;
end

assign xor_out = x ^ xor_ff;
assign and_out = x & ~and_ff;
assign or_out = x | ~or_ff;
assign z = ~(xor_out | and_out | or_out);

initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

endmodule