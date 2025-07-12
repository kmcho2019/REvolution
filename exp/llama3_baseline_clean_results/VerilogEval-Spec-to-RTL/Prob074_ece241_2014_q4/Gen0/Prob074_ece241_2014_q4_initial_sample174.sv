module TopModule (
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg d_xor, d_and, d_or;

initial begin
    d_xor = 0;
    d_and = 0;
    d_or = 0;
end

always @(posedge clk) begin
    d_xor <= (x ^ d_xor);
    d_and <= (x & (~d_and));
    d_or <= (x | (~d_or));
end

assign xor_out = (x ^ d_xor);
assign and_out = (x & (~d_and));
assign or_out = (x | (~d_or));

assign z = ~(xor_out | and_out | or_out);

endmodule