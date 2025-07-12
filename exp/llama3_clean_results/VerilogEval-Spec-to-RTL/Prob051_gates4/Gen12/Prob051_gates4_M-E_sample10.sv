// Universal gate module
module UniversalGate(
    input [3:0] in,
    input [1:0] ctrl, // 0: AND, 1: OR, 2: XOR
    output out
);

    wire and_out, or_out, xor_out;
    assign and_out = in[3] & in[2] & in[1] & in[0];
    assign or_out = in[3] | in[2] | in[1] | in[0];
    assign xor_out = in[3] ^ in[2] ^ in[1] ^ in[0];

    assign out = (ctrl == 2'b00) ? and_out :
                 (ctrl == 2'b01) ? or_out :
                 (ctrl == 2'b10) ? xor_out : 1'bx;

endmodule

// Top-level module instantiating the universal gates
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    UniversalGate andGate(in, 2'b00, out_and);
    UniversalGate orGate(in, 2'b01, out_or);
    UniversalGate xorGate(in, 2'b10, out_xor);

endmodule