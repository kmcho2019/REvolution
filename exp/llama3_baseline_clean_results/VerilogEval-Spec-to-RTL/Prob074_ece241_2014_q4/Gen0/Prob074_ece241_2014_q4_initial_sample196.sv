module TopModule (
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;

assign z = ~(xor_ff_out & and_ff_out & or_ff_out);

always @(posedge clk) begin
    xor_ff_out <= x ^ xor_ff_out;
    and_ff_out <= x & ~and_ff_out;
    or_ff_out  <= x | ~or_ff_out;
end

initial begin
    xor_ff_out = 0;
    and_ff_out = 0;
    or_ff_out  = 0;
end

endmodule