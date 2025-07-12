module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg q_xor, q_and, q_or;

always @(posedge clk) begin
    q_xor <= xor_out;
    q_and <= and_out;
    q_or <= or_out;
end

assign xor_out = x ^ q_xor;
assign and_out = x & (~q_and);
assign or_out = x | (~q_or);
assign z = ~(xor_out | and_out | or_out);

endmodule