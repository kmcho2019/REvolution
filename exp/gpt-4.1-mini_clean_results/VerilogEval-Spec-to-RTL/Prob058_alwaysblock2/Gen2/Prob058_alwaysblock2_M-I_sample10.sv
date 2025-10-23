module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

wire xor_res = a ^ b;

// Continuous assign statement XOR driven from internal wire
assign out_assign = xor_res;

// Combinational always block drives output from shared XOR result
always @(*) begin
    out_always_comb = xor_res;
end

// Sequential always block registers shared XOR result, one clock cycle delayed
always @(posedge clk) begin
    out_always_ff <= xor_res;
end

endmodule