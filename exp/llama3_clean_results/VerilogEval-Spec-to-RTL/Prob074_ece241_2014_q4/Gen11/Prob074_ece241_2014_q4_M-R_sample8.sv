module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;

always @(posedge clk) begin
    xor_out <= x ^ xor_out;
    and_out <= x & ~and_out;
    or_out <= x | ~or_out;
end

assign z = ~(xor_out | and_out | or_out);

endmodule