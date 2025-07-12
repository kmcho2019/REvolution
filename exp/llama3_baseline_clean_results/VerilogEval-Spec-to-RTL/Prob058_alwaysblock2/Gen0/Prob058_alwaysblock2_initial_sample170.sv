module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

// Implementing XOR using assign statement
assign out_assign = a ^ b;

// Implementing XOR using combinational always block
always @(*)
begin
    out_always_comb = a ^ b;
end

// Implementing XOR using clocked always block
always @(posedge clk)
begin
    out_always_ff = a ^ b;
end

endmodule