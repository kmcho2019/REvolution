// Define the LUT module
module LUT(
    input [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000: out = 1'b0; // AND gate: all inputs must be 1
            4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110: out = 1'b0;
            4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule

// Define the OR LUT module
module OR_LUT(
    input [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000: out = 1'b0; // OR gate: any input must be 1
            default: out = 1'b1;
        endcase
    end
endmodule

// Define the XOR LUT module
module XOR_LUT(
    input [3:0] in,
    output out
);
    always @(*) begin
        case (in)
            4'b0000, 4'b1100, 4'b0011, 4'b1111: out = 1'b0; // XOR gate: an even number of inputs must be 1
            default: out = 1'b1;
        endcase
    end
endmodule

// Top-level module instantiating the LUTs
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    LUT and_lut(in, out_and);
    OR_LUT or_lut(in, out_or);
    XOR_LUT xor_lut(in, out_xor);
endmodule