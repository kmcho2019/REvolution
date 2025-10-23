module TopModule (
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

    // First stage: Generate all fundamental signal variants
    wire a_inv = ~a;
    wire b_inv = ~b;

    // Second stage: Construct outputs from fundamental variants
    assign out_and = a & b;
    assign out_or = a | b;
    assign out_xor = a ^ b;
    assign out_nand = a_inv | b_inv;  // DeMorgan's equivalent
    assign out_nor = a_inv & b_inv;   // DeMorgan's equivalent
    assign out_xnor = ~(a ^ b);
    assign out_anotb = a & b_inv;

endmodule