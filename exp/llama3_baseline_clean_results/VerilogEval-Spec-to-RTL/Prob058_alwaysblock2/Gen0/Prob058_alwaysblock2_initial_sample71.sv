module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Continuous assignment for XOR operation
assign out_assign = a ^ b;

// Combinational always block for XOR operation
always @(*) begin
    out_always_comb = a ^ b;
end

// Sequential always block with flip-flop for XOR operation
always @(posedge clk) begin
    out_always_ff = a ^ b;
end

endmodule