module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// 1. Continuous assignment XOR gate
assign out_assign = a ^ b;

// 2. Combinational always block XOR gate
always @(*) begin
    out_always_comb = a ^ b;
end

// 3. Sequential always_ff block XOR gate with flip-flop
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule