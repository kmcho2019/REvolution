module Nand2 (
    input wire a,
    input wire b,
    output wire out
);
    assign out = ~(a & b);
endmodule

module Inv (
    input wire in,
    output wire out
);
    assign out = ~in;
endmodule

module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    wire nand_out;

    // Use NAND gate as first stage
    Nand2 nand_gate(.a(a), .b(b), .out(nand_out));

    // Use explicit inverter module for second stage
    Inv inv_gate(.in(nand_out), .out(out));
endmodule