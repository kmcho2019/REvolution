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

    // Compute intermediate results
    wire a_and_b = a & b;
    wire a_or_b = a | b;
    wire a_xor_b = a ^ b;

    // Assign outputs using intermediate results
    assign out_and  = a_and_b;
    assign out_or   = a_or_b;
    assign out_xor  = a_xor_b;
    assign out_nand = ~a_and_b;
    assign out_nor  = ~a_or_b;
    assign out_xnor = ~a_xor_b;
    assign out_anotb = a & ~b;

endmodule