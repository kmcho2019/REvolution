module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Continuous assignment for XOR gate
assign out_assign = a ^ b;

// Combinational always block for XOR gate
always @(*)
    out_always_comb = a ^ b;

// Clocked always block for sequential XOR gate
always @(posedge clk)
    out_always_ff <= a ^ b;

endmodule