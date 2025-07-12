module TopModule(
    input clk,
    input x,
    output reg z
);

reg xor_out, and_out, or_out;
reg xor_state, and_state, or_state;

initial begin
    xor_state = 0;
    and_state = 0;
    or_state = 0;
end

always @(posedge clk) begin
    xor_state <= x ^ xor_state;
    and_state <= x & ~and_state;
    or_state <= x | ~or_state;
end

always @(*) begin
    xor_out = x ^ xor_state;
    and_out = x & ~and_state;
    or_out = x | ~or_state;
    z = ~(xor_out | and_out | or_out);
end

endmodule