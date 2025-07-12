module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_comb;
assign xor_comb = a ^ b;

assign out_assign = xor_comb;

always @(*) begin
    out_always_comb <= xor_comb;
end

always @(posedge clk) begin
    out_always_ff <= out_always_comb;
end

endmodule