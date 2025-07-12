module TopModule(
    input  clk,
    input  x,
    output z
);

reg xor_out, and_out, or_out;
reg xor_ff, and_ff, or_ff;

always @(posedge clk) begin
    xor_ff <= xor_out;
    and_ff <= and_out;
    or_ff <= or_out;
end

always @(*) begin
    xor_out = x ^ xor_ff;
    and_out = x & ~and_ff;
    or_out = x | ~or_ff;
    z = ~(xor_ff | and_ff | or_ff);
end

endmodule