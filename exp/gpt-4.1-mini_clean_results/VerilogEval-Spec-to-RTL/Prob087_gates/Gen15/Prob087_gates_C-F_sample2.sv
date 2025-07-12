// Fundamental 2-input gate modules for modularity and reuse
module AND_gate(input wire x, input wire y, output wire z);
    assign z = x & y;
endmodule

module OR_gate(input wire x, input wire y, output wire z);
    assign z = x | y;
endmodule

module XOR_gate(input wire x, input wire y, output wire z);
    assign z = x ^ y;
endmodule

// AND_NOT gate module implementing a & ~b
module AND_NOT_gate(input wire x, input wire y, output wire z);
    assign z = x & ~y;
endmodule

// TopModule: uses fundamental gates and direct inversion for complemented outputs
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

    // Shared intermediate wires from fundamental gates
    wire and_ab, or_ab, xor_ab;

    // Instantiate fundamental gates for AND, OR, XOR
    AND_gate and_inst (.x(a), .y(b), .z(and_ab));
    OR_gate  or_inst  (.x(a), .y(b), .z(or_ab));
    XOR_gate xor_inst (.x(a), .y(b), .z(xor_ab));

    // Assign outputs for these gates directly
    assign out_and = and_ab;
    assign out_or  = or_ab;
    assign out_xor = xor_ab;

    // Generate complemented outputs via inversion of intermediate signals
    assign out_nand = ~and_ab;
    assign out_nor  = ~or_ab;
    assign out_xnor = ~xor_ab;

    // Instantiate AND_NOT gate module for a & ~b
    AND_NOT_gate and_not_inst (.x(a), .y(b), .z(out_anotb));

endmodule