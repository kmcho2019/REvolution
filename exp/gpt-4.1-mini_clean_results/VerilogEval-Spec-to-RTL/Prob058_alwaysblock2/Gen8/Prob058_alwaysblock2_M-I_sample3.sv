module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

wire xor_comb = a ^ b;

assign out_assign = xor_comb;
assign out_always_comb = xor_comb;

always @(posedge clk) begin
    out_always_ff <= xor_comb;
end

endmodule