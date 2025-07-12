module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff;
reg and_ff;
reg or_ff;

assign xor_out = x ^ xor_ff;
assign and_out = x & ~and_ff;
assign or_out = x | ~or_ff;

assign z = ~(xor_out | and_out | or_out);

always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

initial begin
    xor_ff = 1'b0;
    and_ff = 1'b0;
    or_ff = 1'b0;
end

endmodule