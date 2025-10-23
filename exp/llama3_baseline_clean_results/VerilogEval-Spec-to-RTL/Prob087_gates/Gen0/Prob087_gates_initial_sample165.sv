module TopModule(
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

assign out_and = a & b;         // AND operation
assign out_or = a | b;          // OR operation
assign out_xor = a ^ b;         // XOR operation
assign out_nand = ~(a & b);     // NAND operation (NOT (a AND b))
assign out_nor = ~(a | b);      // NOR operation (NOT (a OR b))
assign out_xnor = ~(a ^ b);     // XNOR operation (NOT (a XOR b))
assign out_anotb = a & ~b;      // a AND NOT b

endmodule