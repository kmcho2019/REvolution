module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out_ff;
reg and_out_ff;
reg or_out_ff;

assign z = ~(xor_out_ff | and_out_ff | or_out_ff);

always @(posedge clk) begin
    xor_out_ff <= x ^ xor_out_ff;
    and_out_ff <= x & ~and_out_ff;
    or_out_ff <= x | ~or_out_ff;
end

initial begin
    xor_out_ff = 0;
    and_out_ff = 0;
    or_out_ff = 0;
end

endmodule