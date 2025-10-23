module TopModule (
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

    // First compute fundamental operations
    wire and_ab = a & b;
    wire or_ab = a | b;
    wire xor_ab = a ^ b;
    wire not_b = ~b;

    // Assign outputs using shared intermediates
    assign out_and = and_ab;
    assign out_or = or_ab;
    assign out_xor = xor_ab;
    assign out_nand = ~and_ab;  // Shared from AND
    assign out_nor = ~or_ab;    // Shared from OR
    assign out_xnor = ~xor_ab;  // Shared from XOR
    assign out_anotb = a & not_b;

endmodule