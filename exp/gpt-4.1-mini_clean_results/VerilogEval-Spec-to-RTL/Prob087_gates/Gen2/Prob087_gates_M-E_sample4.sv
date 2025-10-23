// Define individual gate modules
module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module NandGate(input wire a, input wire b, output wire out);
    assign out = ~(a & b);
endmodule

module NorGate(input wire a, input wire b, output wire out);
    assign out = ~(a | b);
endmodule

module XnorGate(input wire a, input wire b, output wire out);
    assign out = ~(a ^ b);
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// Top-level module instantiating the gates
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

    AndGate    u_and   (.a(a), .b(b), .out(out_and));
    OrGate     u_or    (.a(a), .b(b), .out(out_or));
    XorGate    u_xor   (.a(a), .b(b), .out(out_xor));
    NandGate   u_nand  (.a(a), .b(b), .out(out_nand));
    NorGate    u_nor   (.a(a), .b(b), .out(out_nor));
    XnorGate   u_xnor  (.a(a), .b(b), .out(out_xnor));
    AndNotGate u_anotb (.a(a), .b(b), .out(out_anotb));

endmodule