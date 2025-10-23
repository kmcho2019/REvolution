// Define basic gate modules
module ANDGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = a & b;
endmodule

module ORGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = a | b;
endmodule

module XORGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = a ^ b;
endmodule

module NANDGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = ~(a & b);
endmodule

module NORGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = ~(a | b);
endmodule

module XNORGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = ~(a ^ b);
endmodule

module ANDNOTGate #(parameter WIDTH = 1)(input [WIDTH-1:0] a, input [WIDTH-1:0] b, output [WIDTH-1:0] out);
    assign out = a & ~b;
endmodule

// Top-level module instantiating the gate modules
module TopModule(
    input  logic a,
    input  logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    // Instantiate the gate modules
    ANDGate and_gate(a, b, out_and);
    ORGate or_gate(a, b, out_or);
    XORGate xor_gate(a, b, out_xor);
    NANDGate nand_gate(a, b, out_nand);
    NORGate nor_gate(a, b, out_nor);
    XNORGate xnor_gate(a, b, out_xnor);
    ANDNOTGate andnot_gate(a, b, out_anotb);

endmodule