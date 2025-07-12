module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Using assign statement to implement XOR gate
assign out_assign = a ^ b;

// Using combinational always block to implement XOR gate
always @(*) begin
    out_always_comb = a ^ b;
end

// Using clocked always block to implement XOR gate with a flip-flop
always @(posedge clk) begin
    out_always_ff <= a ^ b;
end

endmodule