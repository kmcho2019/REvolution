module Nand2 (
    input wire a,
    input wire b,
    output wire out
);
    assign out = ~(a & b);
endmodule

module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    wire nand_out;

    // Directly connect inputs to the NAND gate (no buffers)
    Nand2 nand_gate(.a(a), .b(b), .out(nand_out));

    // Inverter stage replaced by continuous assignment
    assign out = ~nand_out;
endmodule