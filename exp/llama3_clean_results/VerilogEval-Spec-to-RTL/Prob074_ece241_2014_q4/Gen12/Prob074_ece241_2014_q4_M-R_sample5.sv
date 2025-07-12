// TopModule
module TopModule(
    input clk,
    input x,
    output z
);

reg xor_q = 0, and_q = 0, or_q = 0;

always @(posedge clk) begin
    xor_q <= x ^ xor_q;
    and_q <= x & ~and_q;
    or_q <= x | ~or_q;
end

assign z = ~(x ^ xor_q | x & ~and_q | x | ~or_q);

endmodule