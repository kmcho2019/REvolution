// Improved version with additional comments for clarity and maintainability
module TopModule(
    input  a,      // Input 'a' for logical operations
    input  b,      // Input 'b' for logical operations
    output out_and, // Output for a AND b operation
    output out_or,  // Output for a OR b operation
    output out_xor, // Output for a XOR b operation
    output out_nand, // Output for a NAND b operation
    output out_nor,  // Output for a NOR b operation
    output out_xnor, // Output for a XNOR b operation
    output out_anotb // Output for a AND NOT b operation
);

// Directly compute outputs based on input values using bitwise operators
assign out_and  = a & b;  // AND operation
assign out_or   = a | b;  // OR operation
assign out_xor  = a ^ b;  // XOR operation
assign out_nand = ~(a & b); // NAND operation (inversion of AND)
assign out_nor  = ~(a | b); // NOR operation (inversion of OR)
assign out_xnor = ~(a ^ b); // XNOR operation (inversion of XOR)
assign out_anotb = a & (~b); // AND NOT operation

endmodule