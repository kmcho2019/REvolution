module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_result;

assign xor_result = a ^ b;

assign out_assign = xor_result;

always @(*) begin
    out_always_comb = xor_result;
end

always @(posedge clk) begin
    out_always_ff <= xor_result;
end

endmodule