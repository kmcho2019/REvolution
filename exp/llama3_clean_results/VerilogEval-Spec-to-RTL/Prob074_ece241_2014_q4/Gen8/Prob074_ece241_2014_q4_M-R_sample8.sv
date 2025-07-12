module DFF(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

initial begin
    q = 1'b0;
end

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

wire xor_out, and_out, or_out;
wire xor_d, and_d, or_d;

DFF xor_ff(clk, xor_d, xor_out);
DFF and_ff(clk, and_d, and_out);
DFF or_ff(clk, or_d, or_out);

assign xor_d = x ^ xor_out;
assign and_d = x & ~and_out;
assign or_d = x | ~or_out;

assign z = ~(xor_out | and_out | or_out);

endmodule