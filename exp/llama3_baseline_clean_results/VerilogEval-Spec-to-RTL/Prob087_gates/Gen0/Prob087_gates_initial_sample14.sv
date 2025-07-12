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

assign out_and = a & b;           // AND gate
assign out_or = a | b;            // OR gate
assign out_xor = a ^ b;           // XOR gate
assign out_nand = ~(a & b);       // NAND gate (inverted AND)
assign out_nor = ~(a | b);        // NOR gate (inverted OR)
assign out_xnor = ~(a ^ b);       // XNOR gate (inverted XOR)
assign out_anotb = a & (~b);      // A and not B

endmodule