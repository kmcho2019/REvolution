// Define the LUT-based AND gate
module LUT_AND(
    input  [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000: out = 1'b0;
            4'b0001: out = 1'b0;
            4'b0010: out = 1'b0;
            4'b0011: out = 1'b0;
            4'b0100: out = 1'b0;
            4'b0101: out = 1'b0;
            4'b0110: out = 1'b0;
            4'b0111: out = 1'b0;
            4'b1000: out = 1'b0;
            4'b1001: out = 1'b0;
            4'b1010: out = 1'b0;
            4'b1011: out = 1'b0;
            4'b1100: out = 1'b0;
            4'b1101: out = 1'b0;
            4'b1110: out = 1'b0;
            4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule

// Define the LUT-based OR gate
module LUT_OR(
    input  [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000: out = 1'b0;
            4'b0001: out = 1'b1;
            4'b0010: out = 1'b1;
            4'b0011: out = 1'b1;
            4'b0100: out = 1'b1;
            4'b0101: out = 1'b1;
            4'b0110: out = 1'b1;
            4'b0111: out = 1'b1;
            4'b1000: out = 1'b1;
            4'b1001: out = 1'b1;
            4'b1010: out = 1'b1;
            4'b1011: out = 1'b1;
            4'b1100: out = 1'b1;
            4'b1101: out = 1'b1;
            4'b1110: out = 1'b1;
            4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule

// Define the LUT-based XOR gate
module LUT_XOR(
    input  [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000: out = 1'b0;
            4'b0001: out = 1'b1;
            4'b0010: out = 1'b1;
            4'b0011: out = 1'b0;
            4'b0100: out = 1'b1;
            4'b0101: out = 1'b0;
            4'b0110: out = 1'b0;
            4'b0111: out = 1'b1;
            4'b1000: out = 1'b1;
            4'b1001: out = 1'b0;
            4'b1010: out = 1'b0;
            4'b1011: out = 1'b1;
            4'b1100: out = 1'b0;
            4'b1101: out = 1'b1;
            4'b1110: out = 1'b1;
            4'b1111: out = 1'b0;
            default: out = 1'b0;
        endcase
    end
endmodule

// Top-level module instantiating the LUT-based gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    LUT_AND andGate(in, out_and);
    LUT_OR orGate(in, out_or);
    LUT_XOR xorGate(in, out_xor);
endmodule