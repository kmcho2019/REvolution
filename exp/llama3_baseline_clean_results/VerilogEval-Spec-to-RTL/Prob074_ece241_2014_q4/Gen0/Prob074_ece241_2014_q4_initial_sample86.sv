module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg dff_xor, dff_and, dff_or;

always @(posedge clk) begin
    dff_xor <= xor_out;
    dff_and <= and_out;
    dff_or <= or_out;
end

assign xor_out = x ^ dff_xor;
assign and_out = x & (~dff_and);
assign or_out = x | (~dff_or);

assign z = ~(xor_out | and_out | or_out);

initial begin
    dff_xor = 0;
    dff_and = 0;
    dff_or = 0;
end

endmodule