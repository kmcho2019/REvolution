module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire ab_xor;
assign ab_xor = a ^ b;

// q = (state & ~ab_xor) | (~state & ab_xor)
assign q = (state & ~ab_xor) | (~state & ab_xor);

always @(posedge clk) begin
    state <= q;
end

endmodule