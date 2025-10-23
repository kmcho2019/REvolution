// Define a parameterizable gate library
module ParamANDGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = a & b;
endmodule

module ParamORGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = a | b;
endmodule

module ParamXORGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = a ^ b;
endmodule

module ParamNANDGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = ~(a & b);
endmodule

module ParamNORGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = ~(a | b);
endmodule

module ParamXNORGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = ~(a ^ b);
endmodule

module ParamANDNOTGate #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] out
);
    assign out = a & ~b;
endmodule

// Define the logic combiner
module LogicCombiner(
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
    ParamANDGate and_gate(.a(a), .b(b), .out(out_and));
    ParamORGate or_gate(.a(a), .b(b), .out(out_or));
    ParamXORGate xor_gate(.a(a), .b(b), .out(out_xor));
    ParamNANDGate nand_gate(.a(a), .b(b), .out(out_nand));
    ParamNORGate nor_gate(.a(a), .b(b), .out(out_nor));
    ParamXNORGate xnor_gate(.a(a), .b(b), .out(out_xnor));
    ParamANDNOTGate anotb_gate(.a(a), .b(b), .out(out_anotb));
endmodule

// Define the top-level module
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
    LogicCombiner combiner(
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .out_nand(out_nand),
        .out_nor(out_nor),
        .out_xnor(out_xnor),
        .out_anotb(out_anotb)
    );
endmodule