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

// Intermediate variables for basic operations
wire and_result = a & b;
wire or_result = a | b;
wire xor_result = a ^ b;

// Assign outputs directly using intermediate results and NOT operator where necessary
assign out_and = and_result;  // AND gate
assign out_or = or_result;    // OR gate
assign out_xor = xor_result;  // XOR gate
assign out_nand = ~and_result; // NAND gate
assign out_nor = ~or_result;    // NOR gate
assign out_xnor = ~xor_result;  // XNOR gate
assign out_anotb = a & (~b);    // AND-NOT gate

endmodule