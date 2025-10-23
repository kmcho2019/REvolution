module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Continuous assignment statement for XOR gate
assign out_assign = a ^ b;

// Combinational always block for XOR gate
always @(*) begin
    out_always_comb = a ^ b;
end

// Clocked always block to introduce a flip-flop for XOR gate
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule