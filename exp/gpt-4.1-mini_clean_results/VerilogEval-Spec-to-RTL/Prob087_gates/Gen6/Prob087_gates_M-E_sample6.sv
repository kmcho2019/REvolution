module TopModule (
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    // Encode inputs in a 2-bit vector: bit0 = a & ~b, bit1 = ~a & b
    wire [1:0] ab_enc;
    assign ab_enc[0] = a & ~b;  // a AND NOT b
    assign ab_enc[1] = ~a & b;  // NOT a AND b

    // Use ab_enc to generate out_xor and out_anotb directly
    // out_xor = ab_enc[0] | ab_enc[1]
    // out_anotb = ab_enc[0]

    // Intermediate signals for a & b and ~a & ~b
    wire a_and_b = a & b;
    wire na_and_nb = ~a & ~b;

    assign out_and   = a_and_b;
    assign out_or    = a | b;
    assign out_xor   = ab_enc[0] | ab_enc[1];
    assign out_nand  = ~a_and_b;
    assign out_nor   = na_and_nb;
    assign out_xnor  = na_and_nb | a_and_b; // (a xnor b) = (a&b) + (~a&~b)
    assign out_anotb = ab_enc[0];

endmodule