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

    // Shared intermediate signals
    wire a_and_b  = a & b;
    wire a_or_b   = a | b;
    wire a_xor_b  = a ^ b;

    assign out_and   = a_and_b;
    assign out_or    = a_or_b;
    assign out_xor   = a_xor_b;
    assign out_nand  = ~a_and_b;
    assign out_nor   = ~a_or_b;
    assign out_xnor  = ~a_xor_b;
    assign out_anotb = a & (~b);

endmodule