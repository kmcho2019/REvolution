module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

reg a_reg, b_reg;

// Continuous assign directly computes XOR
assign out_assign = a ^ b;

// Combinational always block computes XOR without intermediate wire
always @(*) begin
    out_always_comb = a ^ b;
end

// Clocked always block with registered inputs and then XOR calculation
always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    out_always_ff <= a_reg ^ b_reg;
end

endmodule