module TopModule(
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

assign out_and = a & b;  // Using bitwise AND for direct implementation
assign out_or = a | b;    // Using bitwise OR for direct implementation
assign out_xor = a ^ b;  // Using bitwise XOR for direct implementation
assign out_nand = ~(a & b); // Deriving NAND using negation of AND
assign out_nor = ~(a | b);    // Deriving NOR using negation of OR
assign out_xnor = ~(a ^ b);  // Deriving XNOR using negation of XOR
assign out_anotb = a & (~b); // Implementing AND-NOT gate using bitwise AND and negation

endmodule