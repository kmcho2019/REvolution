// Define the LUTs for each gate
module ANDGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b0001};
    assign out = lut[in];
endmodule

module ORGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b0011, 4'b0111, 4'b1011, 4'b1111};
    assign out = lut[in];
endmodule

module XORGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b0101};
    assign out = lut[in];
endmodule

module NANDGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b1110};
    assign out = lut[in];
endmodule

module NORGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b1000};
    assign out = lut[in];
endmodule

module XNORGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b1001};
    assign out = lut[in];
endmodule

module ANDNOTGate(input logic [1:0] in, output logic out);
    logic [3:0][0:0] lut = '{4'b0010};
    assign out = lut[in];
endmodule

// TopModule instantiates the LUTs and generates output values
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

    logic [1:0] in;
    assign in = {a, b};

    ANDGate and_gate(in, out_and);
    ORGate or_gate(in, out_or);
    XORGate xor_gate(in, out_xor);
    NANDGate nand_gate(in, out_nand);
    NORGate nor_gate(in, out_nor);
    XNORGate xnor_gate(in, out_xnor);
    ANDNOTGate andnot_gate(in, out_anotb);

endmodule