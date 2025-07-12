// Basic two-input gate modules with direct logic assignments

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

// TopModule combining modular basic gates with direct inverted outputs for efficiency

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

    // Shared basic gate outputs
    wire and_ab, or_ab, xor_ab;

    AndGate    u_and   (.a(a), .b(b), .out(and_ab));
    OrGate     u_or    (.a(a), .b(b), .out(or_ab));
    XorGate    u_xor   (.a(a), .b(b), .out(xor_ab));
    AndNotGate u_anotb (.a(a), .b(b), .out(out_anotb));

    // Assign outputs
    assign out_and  = and_ab;
    assign out_or   = or_ab;
    assign out_xor  = xor_ab;
    assign out_nand = ~and_ab;
    assign out_nor  = ~or_ab;
    assign out_xnor = ~xor_ab;

endmodule