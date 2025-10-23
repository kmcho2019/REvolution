module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_internal;
assign xor_internal = a ^ b;

assign out_assign = xor_internal;

always @(*) begin
    out_always_comb = xor_internal;
end

always @(posedge clk) begin
    out_always_ff <= xor_internal;
end

endmodule