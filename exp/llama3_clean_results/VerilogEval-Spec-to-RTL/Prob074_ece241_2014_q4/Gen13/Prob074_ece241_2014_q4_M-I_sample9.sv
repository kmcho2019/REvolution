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

wire xor_out, and_out, or_out;

DFF xor_ff(clk, 1'b0, x ^ xor_out, xor_out);
DFF and_ff(clk, 1'b0, x & ~and_out, and_out);
DFF or_ff(clk, 1'b0, x | ~or_out, or_out);

assign z = ~(xor_out | and_out | or_out);

endmodule