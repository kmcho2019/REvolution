module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Combine inputs into 2-bit address
    wire [1:0] ab = {a, b};

    // Truth table implementation (ROM-style)
    always @(*) begin
        case (ab)
            2'b00: {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0001101;
            2'b01: {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0011010;
            2'b10: {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0111000;
            2'b11: {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b1100010;
            default: {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0000000;
        endcase
    end

endmodule