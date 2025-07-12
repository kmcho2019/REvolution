module TopModule (
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        // AND gate implementation
        case (in)
            4'b1111: out_and = 1'b1;
            default: out_and = 1'b0;
        endcase

        // OR gate implementation
        case (in)
            4'b0000: out_or = 1'b0;
            default: out_or = 1'b1;
        endcase

        // XOR gate implementation (parity check)
        case (^in)
            1'b1: out_xor = 1'b1;
            1'b0: out_xor = 1'b0;
        endcase
    end

endmodule