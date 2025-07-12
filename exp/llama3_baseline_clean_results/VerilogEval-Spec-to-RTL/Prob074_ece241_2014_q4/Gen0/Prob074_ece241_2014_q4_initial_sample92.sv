module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;
reg xor_out, and_out, or_out;

always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

assign xor_out = x ^ xor_ff;
assign and_out = x & (~and_ff);
assign or_out = x | (~or_ff);
assign z = ~(xor_ff | and_ff | or_ff);

initial begin
    xor_ff = 0;
    and_ff = 0;
    or_ff = 0;
end

endmodule