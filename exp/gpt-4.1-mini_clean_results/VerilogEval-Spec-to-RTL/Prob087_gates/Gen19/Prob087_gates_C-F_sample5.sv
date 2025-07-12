// Basic two-input gate modules: AND, OR, XOR, AND_NOT

module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// TopModule: instantiate basic gates, produce complemented outputs by direct inversion

module TopModule(
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

    wire and_int, or_int, xor_int;

    // Instantiate fundamental gate modules
    AndGate    and_inst   (.a(a), .b(b), .out(and_int));
    OrGate     or_inst    (.a(a), .b(b), .out(or_int));
    XorGate    xor_inst   (.a(a), .b(b), .out(xor_int));
    AndNotGate andnot_inst(.a(a), .b(b), .out(out_anotb));

    // Direct continuous assignments for outputs and their complements
    assign out_and  = and_int;
    assign out_or   = or_int;
    assign out_xor  = xor_int;
    assign out_nand = ~and_int;
    assign out_nor  = ~or_int;
    assign out_xnor = ~xor_int;

endmodule