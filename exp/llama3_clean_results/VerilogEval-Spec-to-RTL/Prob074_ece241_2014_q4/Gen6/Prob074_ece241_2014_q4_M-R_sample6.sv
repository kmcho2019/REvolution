module TopModule(
    input clk,
    input x,
    output z
);

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

wire xor_out = x ^ xor_state;
wire and_out = x & ~and_state;
wire or_out = x | ~or_state;

assign z = ~(xor_out | and_out | or_out);

endmodule