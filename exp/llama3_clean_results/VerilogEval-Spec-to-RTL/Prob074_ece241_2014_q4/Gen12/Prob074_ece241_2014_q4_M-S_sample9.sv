module DFF(
    input clk,
    input d,
    output reg q = 1'b0
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

wire xor_out, and_out, or_out;

DFF xor_ff(clk, x ^ xor_out, xor_out);
DFF and_ff(clk, x & ~and_out, and_out);
DFF or_ff(clk, x | ~or_out, or_out);

assign z = ~(xor_out | and_out | or_out);

endmodule