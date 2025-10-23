module NAND_Gate(
    input  a,
    input  b,
    output out
);
    assign out = ~(a & b);
endmodule

module XOR_Gate(
    input  a,
    input  b,
    output out
);
    assign out = a ^ b;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire nand_out1, nand_out2, xor_out;

    NAND_Gate nand_gate1(
      .a(a),
      .b(b),
      .out(nand_out1)
    );

    NAND_Gate nand_gate2(
      .a(c),
      .b(d),
      .out(nand_out2)
    );

    XOR_Gate xor_gate(
      .a(nand_out1),
      .b(nand_out2),
      .out(xor_out)
    );

    assign out = ~xor_out;
    assign out_n = xor_out;
endmodule