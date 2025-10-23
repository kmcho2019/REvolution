module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out_ff;
reg and_out_ff;
reg or_out_ff;

wire xor_out;
wire and_out;
wire or_out;

assign xor_out = x ^ xor_out_ff;
assign and_out = x & (~and_out_ff);
assign or_out = x | (~or_out_ff);

always @(posedge clk) begin
    xor_out_ff <= xor_out;
    and_out_ff <= and_out;
    or_out_ff <= or_out;
end

assign z = ~(xor_out_ff | and_out_ff | or_out_ff);

initial begin
    xor_out_ff <= 1'b0;
    and_out_ff <= 1'b0;
    or_out_ff <= 1'b0;
end

endmodule