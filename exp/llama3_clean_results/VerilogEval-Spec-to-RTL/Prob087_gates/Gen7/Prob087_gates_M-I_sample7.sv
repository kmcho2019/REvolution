// Define integrated gate modules for complementary functions
module AND_NAND_Gate(input a, input b, output and_out, output nand_out);
    assign and_out = a && b;
    assign nand_out = ~(a && b);
endmodule

module OR_NOR_Gate(input a, input b, output or_out, output nor_out);
    assign or_out = a || b;
    assign nor_out = ~(a || b);
endmodule

module XOR_XNOR_Gate(input a, input b, output xor_out, output xnor_out);
    assign xor_out = a ^ b;
    assign xnor_out = ~(a ^ b);
endmodule

// TopModule instantiates the integrated gate modules and implements AND-NOT directly
module TopModule(
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

    AND_NAND_Gate and_nand_gate(a, b, out_and, out_nand);
    OR_NOR_Gate or_nor_gate(a, b, out_or, out_nor);
    XOR_XNOR_Gate xor_xnor_gate(a, b, out_xor, out_xnor);
    assign out_anotb = a && ~b;

endmodule