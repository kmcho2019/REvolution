module TopModule (
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out_and,  // Output of AND operation between a and b
    output out_or,   // Output of OR operation between a and b
    output out_xor,  // Output of XOR operation between a and b
    output out_nand, // Output of NAND operation between a and b
    output out_nor,  // Output of NOR operation between a and b
    output out_xnor, // Output of XNOR operation between a and b
    output out_anotb // Output of 'a and not b' operation
);

// Assign outputs based on bitwise operations
assign out_and  = a & b;  // AND gate
assign out_or   = a | b;  // OR gate
assign out_xor  = a ^ b;  // XOR gate
assign out_nand = ~(a & b); // NAND gate
assign out_nor  = ~(a | b); // NOR gate
assign out_xnor = ~(a ^ b); // XNOR gate
assign out_anotb = a & ~b;  // 'a and not b' operation

endmodule