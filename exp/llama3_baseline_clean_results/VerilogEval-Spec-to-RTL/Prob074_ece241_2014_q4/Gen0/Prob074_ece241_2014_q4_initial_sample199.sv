module TopModule (
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;
wire xor_out, and_out, or_out;

assign xor_out = x ^ xor_ff_out;
assign and_out = x & (~and_ff_out);
assign or_out  = x | (~or_ff_out);

always @(posedge clk) begin
    xor_ff_out <= xor_out;
    and_ff_out <= and_out;
    or_ff_out  <= or_out;
end

assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

initial begin
    xor_ff_out = 0;
    and_ff_out = 0;
    or_ff_out = 0;
end

endmodule