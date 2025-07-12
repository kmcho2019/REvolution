module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg xor_out, and_out, or_out;
reg xor_d, and_d, or_d;

DFF xor_ff(clk, reset, xor_d, xor_out);
DFF and_ff(clk, reset, and_d, and_out);
DFF or_ff(clk, reset, or_d, or_out);

always @(*) begin
    xor_d = x ^ xor_out;
    and_d = x & ~and_out;
    or_d = x | ~or_out;
    z = ~(xor_out | and_out | or_out);
end

endmodule