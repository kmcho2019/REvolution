module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    always @(*) begin
        case(in)
            4'b0000: {out_and, out_or, out_xor} = 3'b000;
            4'b0001: {out_and, out_or, out_xor} = 3'b001;
            4'b0010: {out_and, out_or, out_xor} = 3'b001;
            4'b0011: {out_and, out_or, out_xor} = 3'b010;
            4'b0100: {out_and, out_or, out_xor} = 3'b001;
            4'b0101: {out_and, out_or, out_xor} = 3'b010;
            4'b0110: {out_and, out_or, out_xor} = 3'b010;
            4'b0111: {out_and, out_or, out_xor} = 3'b011;
            4'b1000: {out_and, out_or, out_xor} = 3'b001;
            4'b1001: {out_and, out_or, out_xor} = 3'b010;
            4'b1010: {out_and, out_or, out_xor} = 3'b010;
            4'b1011: {out_and, out_or, out_xor} = 3'b011;
            4'b1100: {out_and, out_or, out_xor} = 3'b010;
            4'b1101: {out_and, out_or, out_xor} = 3'b011;
            4'b1110: {out_and, out_or, out_xor} = 3'b011;
            4'b1111: {out_and, out_or, out_xor} = 3'b111;
            default: {out_and, out_or, out_xor} = 3'b000;
        endcase
    end

endmodule