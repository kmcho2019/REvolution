module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_val;
assign xor_val = a ^ b;

assign out_assign = xor_val;

always @(a or b) begin
    out_always_comb = xor_val;
end

always @(posedge clk) begin
    out_always_ff <= xor_val;
end

endmodule