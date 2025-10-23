module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;

assign xor_in = x ^ xor_out;
assign and_in = x & ~and_out;
assign or_in = x | ~or_out;

always @(posedge clk) begin
    xor_out <= xor_in;
    and_out <= and_in;
    or_out <= or_in;
end

assign z = ~(xor_out | and_out | or_out);

endmodule