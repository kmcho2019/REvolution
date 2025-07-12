module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Treat input combination as 2-bit address
    reg [6:0] lut_out;  // Pack all 7 outputs into one register
    
    always @(*) begin
        case ({a, b})
            2'b00: lut_out = 7'b0001011;  // and, or, xor, nand, nor, xnor, anotb
            2'b01: lut_out = 7'b0111100;
            2'b10: lut_out = 7'b0111001;
            2'b11: lut_out = 7'b1100100;
        endcase
    end

    // Unpack the LUT outputs
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut_out;

endmodule