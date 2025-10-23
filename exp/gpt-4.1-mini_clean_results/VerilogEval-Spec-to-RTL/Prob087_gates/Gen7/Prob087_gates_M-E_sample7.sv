// Basic gate modules for modular design
module AND_gate(input wire x, input wire y, output wire z);
    assign z = x & y;
endmodule

module OR_gate(input wire x, input wire y, output wire z);
    assign z = x | y;
endmodule

module XOR_gate(input wire x, input wire y, output wire z);
    assign z = x ^ y;
endmodule

module INV_gate(input wire x, output wire z);
    assign z = ~x;
endmodule

module AND_NOT_gate(input wire x, input wire y, output wire z);
    assign z = x & (~y);
endmodule

// TopModule using above building blocks
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

    // Intermediate wires for fundamental gates
    wire and_ab, or_ab, xor_ab;
    wire nand_ab, nor_ab, xnor_ab;

    // Instantiate basic gates
    AND_gate and_inst (.x(a), .y(b), .z(and_ab));
    OR_gate  or_inst  (.x(a), .y(b), .z(or_ab));
    XOR_gate xor_inst (.x(a), .y(b), .z(xor_ab));

    // Instantiate inverters to generate complemented outputs
    INV_gate inv_nand (.x(and_ab), .z(nand_ab));
    INV_gate inv_nor  (.x(or_ab),  .z(nor_ab));
    INV_gate inv_xnor (.x(xor_ab), .z(xnor_ab));

    // Instantiate AND_NOT gate for out_anotb
    AND_NOT_gate and_not_inst (.x(a), .y(b), .z(out_anotb));

    // Output assignments
    assign out_and  = and_ab;
    assign out_or   = or_ab;
    assign out_xor  = xor_ab;
    assign out_nand = nand_ab;
    assign out_nor  = nor_ab;
    assign out_xnor = xnor_ab;

endmodule