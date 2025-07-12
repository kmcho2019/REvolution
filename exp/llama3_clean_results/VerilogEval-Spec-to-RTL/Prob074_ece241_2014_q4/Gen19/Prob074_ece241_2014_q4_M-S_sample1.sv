module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_q = 0, and_q = 0, or_q = 0;

always @(posedge clk) begin
    xor_q <= x ^ xor_q;
    and_q <= x & ~and_q;
    or_q <= x | ~or_q;
    z <= ~(xor_q | and_q | or_q);
end

endmodule