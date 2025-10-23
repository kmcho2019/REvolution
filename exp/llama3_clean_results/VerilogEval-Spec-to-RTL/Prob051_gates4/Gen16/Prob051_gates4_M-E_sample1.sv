module ParamGate(
    input  [3:0] in,
    input  [1:0] op,  // 2'b00: AND, 2'b01: OR, 2'b10: XOR
    output out
);
    reg [3:0] temp;
    always @(*) begin
        case (op)
            2'b00: out = in[3] & in[2] & in[1] & in[0];
            2'b01: out = in[3] | in[2] | in[1] | in[0];
            2'b10: out = in[3] ^ in[2] ^ in[1] ^ in[0];
            default: out = 1'b0;
        endcase
    end
endmodule

module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    ParamGate andGate(in, 2'b00, out_and);
    ParamGate orGate(in, 2'b01, out_or);
    ParamGate xorGate(in, 2'b10, out_xor);
endmodule