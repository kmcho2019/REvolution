module Inv (
    input  wire in,
    output wire out
);
    assign out = ~in;
endmodule

module NandGate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = ~(a & b);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    wire a_inv;
    wire b_inv;
    wire nand_out;

    // Invert inputs
    Inv inv_a(.in(a), .out(a_inv));
    Inv inv_b(.in(b), .out(b_inv));

    // NAND gate of inverted inputs
    NandGate nand_inst(.a(a_inv), .b(b_inv), .y(nand_out));

    // q is NAND of inverted inputs => q = a AND b
    assign q = nand_out;
endmodule