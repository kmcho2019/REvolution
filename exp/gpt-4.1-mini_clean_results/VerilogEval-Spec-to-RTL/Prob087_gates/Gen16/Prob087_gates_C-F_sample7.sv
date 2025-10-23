// Two-input gate modules for core logic with explicit interfaces
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

// Top-level module combining modular two-input gates and inline inversion for complementary outputs
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

    // Compute shared intermediate signals once using modular gates
    wire and_ab;
    wire or_ab;
    wire xor_ab;

    AndGate u_and(.a(a), .b(b), .out(and_ab));
    OrGate  u_or (.a(a), .b(b), .out(or_ab));
    XorGate u_xor(.a(a), .b(b), .out(xor_ab));

    // Direct inline inversion of shared signals for NAND, NOR, XNOR outputs (no module overhead)
    assign out_nand = ~and_ab;
    assign out_nor  = ~or_ab;
    assign out_xnor = ~xor_ab;

    // Direct assignment of shared signals for AND, OR, XOR outputs
    assign out_and = and_ab;
    assign out_or  = or_ab;
    assign out_xor = xor_ab;

    // Use modular AndNotGate for a & ~b as it involves direct inputs and slight complexity
    AndNotGate u_anotb(.a(a), .b(b), .out(out_anotb));

endmodule