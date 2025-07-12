module TopModule(
    input clk,
    input x,
    output z
);

reg xor_ff, and_ff, or_ff;

assign xor_in = x ^ xor_ff;
assign and_in = x & ~and_ff;
assign or_in = x | ~or_ff;

always @(posedge clk) begin
    xor_ff <= xor_in;
    and_ff <= and_in;
    or_ff <= or_in;
end

assign z = ~(xor_ff | and_ff | or_ff);

endmodule