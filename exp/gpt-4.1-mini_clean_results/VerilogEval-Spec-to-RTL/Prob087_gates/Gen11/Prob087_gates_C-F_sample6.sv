// Define individual basic gate modules with straightforward interfaces

module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module NandGate(input wire in, output wire out);
    assign out = ~in;
endmodule

module NorGate(input wire in, output wire out);
    assign out = ~in;
endmodule

module XnorGate(input wire in, output wire out);
    assign out = ~in;
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// Top-level module combining modularity and shared intermediate signals for efficiency

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

    // Compute shared intermediate signals once
    wire and_ab;
    wire or_ab;
    wire xor_ab;

    AndGate u_and(.a(a), .b(b), .out(and_ab));
    OrGate  u_or (.a(a), .b(b), .out(or_ab));
    XorGate u_xor(.a(a), .b(b), .out(xor_ab));

    // Inverted outputs reuse shared signals
    NandGate u_nand(.in(and_ab), .out(out_nand));
    NorGate  u_nor (.in(or_ab),  .out(out_nor));
    XnorGate u_xnor(.in(xor_ab), .out(out_xnor));

    // Direct outputs from shared signals
    assign out_and = and_ab;
    assign out_or  = or_ab;
    assign out_xor = xor_ab;

    // Direct combinational logic for a & ~b
    AndNotGate u_anotb(.a(a), .b(b), .out(out_anotb));

endmodule