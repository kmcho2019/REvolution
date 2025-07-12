module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND LUT - implements 4-input AND truth table
    always @(*) begin
        case(in)
            4'b0000: out_and = 1'b0;
            4'b0001: out_and = 1'b0;
            4'b0010: out_and = 1'b0;
            4'b0011: out_and = 1'b0;
            4'b0100: out_and = 1'b0;
            4'b0101: out_and = 1'b0;
            4'b0110: out_and = 1'b0;
            4'b0111: out_and = 1'b0;
            4'b1000: out_and = 1'b0;
            4'b1001: out_and = 1'b0;
            4'b1010: out_and = 1'b0;
            4'b1011: out_and = 1'b0;
            4'b1100: out_and = 1'b0;
            4'b1101: out_and = 1'b0;
            4'b1110: out_and = 1'b0;
            4'b1111: out_and = 1'b1;
            default: out_and = 1'b0;
        endcase
    end

    // OR LUT - implements 4-input OR truth table
    always @(*) begin
        case(in)
            4'b0000: out_or = 1'b0;
            default: out_or = 1'b1;
        endcase
    end

    // XOR LUT - implements 4-input XOR truth table
    always @(*) begin
        case(in)
            4'b0000: out_xor = 1'b0;
            4'b0001: out_xor = 1'b1;
            4'b0010: out_xor = 1'b1;
            4'b0011: out_xor = 1'b0;
            4'b0100: out_xor = 1'b1;
            4'b0101: out_xor = 1'b0;
            4'b0110: out_xor = 1'b0;
            4'b0111: out_xor = 1'b1;
            4'b1000: out_xor = 1'b1;
            4'b1001: out_xor = 1'b0;
            4'b1010: out_xor = 1'b0;
            4'b1011: out_xor = 1'b1;
            4'b1100: out_xor = 1'b0;
            4'b1101: out_xor = 1'b1;
            4'b1110: out_xor = 1'b1;
            4'b1111: out_xor = 1'b0;
            default: out_xor = 1'b0;
        endcase
    end

endmodule