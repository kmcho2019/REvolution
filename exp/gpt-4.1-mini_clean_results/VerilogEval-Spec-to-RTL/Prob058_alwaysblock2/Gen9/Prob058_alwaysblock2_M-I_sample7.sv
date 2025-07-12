module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

// Compute XOR once
wire xor_ab = a ^ b;

// Continuous assign for out_assign
assign out_assign = xor_ab;

// Combinational always block for out_always_comb
always @(*) begin
    out_always_comb = xor_ab;  // Changed to blocking assignment for combinational logic
end

// Sequential always block for out_always_ff
always @(posedge clk) begin
    out_always_ff <= xor_ab;
end

endmodule