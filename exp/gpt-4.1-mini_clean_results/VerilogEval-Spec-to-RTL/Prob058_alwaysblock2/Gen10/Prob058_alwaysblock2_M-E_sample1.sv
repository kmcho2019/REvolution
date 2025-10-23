module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_wire;
reg comb_reg;

assign xor_wire = a ^ b;

always @(*) begin
    comb_reg = xor_wire;
    out_always_comb = comb_reg;
end

always @(posedge clk) begin
    out_always_ff <= comb_reg;
end

assign out_assign = xor_wire;

endmodule