module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg xor_d, and_d, or_d;

DFF xor_ff(clk, xor_d, xor_out);
DFF and_ff(clk, and_d, and_out);
DFF or_ff(clk, or_d, or_out);

always @(*) begin
    xor_d = x ^ xor_out;
    and_d = x & ~and_out;
    or_d = x | ~or_out;
end

assign z = ~(xor_out | and_out | or_out);

initial begin
    xor_out = 1'b0;
    and_out = 1'b0;
    or_out = 1'b0;
end

endmodule