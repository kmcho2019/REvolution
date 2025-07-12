module TopModule (
    input wire a,
    input wire b,
    output wire out_and,    // a AND b
    output wire out_or,     // a OR b
    output wire out_xor,    // a XOR b
    output wire out_nand,   // a NAND b
    output wire out_nor,    // a NOR b
    output wire out_xnor,   // a XNOR b
    output wire out_anotb   // a AND (NOT b)
);

    // Direct continuous assignments for all logic outputs
    assign out_and   = a & b;
    assign out_or    = a | b;
    assign out_xor   = a ^ b;
    assign out_nand  = ~(a & b);
    assign out_nor   = ~(a | b);
    assign out_xnor  = ~(a ^ b);
    assign out_anotb = a & ~b;

endmodule