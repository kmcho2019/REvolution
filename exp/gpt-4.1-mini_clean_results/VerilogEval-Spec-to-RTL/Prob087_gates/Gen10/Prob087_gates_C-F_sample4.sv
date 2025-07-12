// Parametrized and flexible gate modules supporting direct inputs or computed shared signals
module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module NandGate(input wire and_in, output wire out);
    assign out = ~and_in;
endmodule

module NorGate(input wire or_in, output wire out);
    assign out = ~or_in;
endmodule

module XnorGate(input wire xor_in, output wire out);
    assign out = ~xor_in;
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// Top-level module instantiating gates with shared intermediate signals for efficiency
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

    // Shared intermediate signals computed once
    wire and_ab;
    wire or_ab;
    wire xor_ab;

    AndGate u_and(.a(a), .b(b), .out(and_ab));
    OrGate  u_or (.a(a), .b(b), .out(or_ab));
    XorGate u_xor(.a(a), .b(b), .out(xor_ab));

    // Use shared intermediate signals for inverted outputs
    NandGate u_nand(.and_in(and_ab), .out(out_nand));
    NorGate  u_nor (.or_in(or_ab),  .out(out_nor));
    XnorGate u_xnor(.xor_in(xor_ab),.out(out_xnor));

    assign out_and = and_ab;
    assign out_or  = or_ab;
    assign out_xor = xor_ab;

    AndNotGate u_anotb(.a(a), .b(b), .out(out_anotb));

endmodule