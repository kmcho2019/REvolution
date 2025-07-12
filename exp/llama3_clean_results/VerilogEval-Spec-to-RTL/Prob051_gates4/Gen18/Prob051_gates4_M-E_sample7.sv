// Define the interface or base module for gates
module Gate(
    input [3:0] in,
    output out
);

endmodule

// Implement the 4-input AND gate using a lookup table
module FourInputAND(
    input [3:0] in,
    output out
);
    reg [1:0] addr;
    reg [0:0] out_reg;

    always @(in) begin
        case (in)
            4'b1111: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;
endmodule

// Implement the 4-input OR gate using a lookup table
module FourInputOR(
    input [3:0] in,
    output out
);
    reg [1:0] addr;
    reg [0:0] out_reg;

    always @(in) begin
        case (in)
            4'b0000: out_reg = 1'b0;
            default: out_reg = 1'b1;
        endcase
    end

    assign out = out_reg;
endmodule

// Implement the 4-input XOR gate using a lookup table
module FourInputXOR(
    input [3:0] in,
    output out
);
    reg [1:0] addr;
    reg [0:0] out_reg;

    always @(in) begin
        case (in)
            4'b0001, 4'b0010, 4'b0100, 4'b1000,
            4'b0111, 4'b1011, 4'b1101, 4'b1110: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end

    assign out = out_reg;
endmodule

// Top-level module instantiating the 4-input gates
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    FourInputAND andGate(in, out_and);
    FourInputOR orGate(in, out_or);
    FourInputXOR xorGate(in, out_xor);
endmodule