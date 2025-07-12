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

    // Combine inputs into a 2-bit vector for case statement
    wire [1:0] ab = {a, b};

    // Use a case statement to implement all outputs in parallel
    always @(*) begin
        case (ab)
            2'b00: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0001110;
            end
            2'b01: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0011010;
            end
            2'b10: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0011101;
            end
            2'b11: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b1100010;
            end
            default: begin
                {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 7'b0000000;
            end
        endcase
    end

endmodule