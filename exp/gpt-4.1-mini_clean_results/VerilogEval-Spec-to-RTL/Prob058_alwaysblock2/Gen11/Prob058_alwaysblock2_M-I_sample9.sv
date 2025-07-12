module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Shared XOR result to reduce gate count
wire xor_ab = a ^ b;

assign out_assign = xor_ab;

always @(*) begin
    out_always_comb = xor_ab;
end

always @(posedge clk) begin
    out_always_ff <= xor_ab;
end

endmodule