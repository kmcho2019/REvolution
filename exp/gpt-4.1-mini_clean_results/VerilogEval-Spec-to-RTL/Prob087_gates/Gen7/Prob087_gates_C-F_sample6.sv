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
    wire na = ~a;
    wire nb = ~b;
    wire a_and_b = a & b;
    wire a_or_b  = a | b;
    wire na_and_nb = na & nb;
    wire a_and_not_b = a & nb;
    wire not_a_and_b = na & b;

    // Outputs using shared intermediates
    assign out_and   = a_and_b;
    assign out_or    = a_or_b;
    assign out_xor   = a_and_not_b | not_a_and_b;
    assign out_nand  = ~a_and_b;
    assign out_nor   = na_and_nb;
    assign out_xnor  = a_and_b | na_and_nb;
    assign out_anotb = a_and_not_b;

endmodule