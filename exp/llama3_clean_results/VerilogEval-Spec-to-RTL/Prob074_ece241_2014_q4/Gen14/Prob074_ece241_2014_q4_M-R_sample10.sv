module DFF(
    input clk,
    input rst,
    input d,
    output reg q
);

initial q = 1'b0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input x,
    output z
);

reg xor_out, and_out, or_out;

wire xor_in, and_in, or_in;

assign xor_in = x ^ xor_out;
assign and_in = x & ~and_out;
assign or_in = x | ~or_out;

DFF xor_ff(clk, 1'b0, xor_in, xor_out);
DFF and_ff(clk, 1'b0, and_in, and_out);
DFF or_ff(clk, 1'b0, or_in, or_out);

assign z = ~(xor_out | and_out | or_out);

endmodule