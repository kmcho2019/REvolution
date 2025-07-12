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

    reg [6:0] lut_out;  // Stores all 7 outputs
    
    always @(*) begin
        case ({a, b})
            2'b00: lut_out = 7'b0_0_0_1_1_1_0;  // and, or, xor, nand, nor, xnor, anotb
            2'b01: lut_out = 7'b0_1_1_1_0_0_0;
            2'b10: lut_out = 7'b0_1_1_1_0_0_1;
            2'b11: lut_out = 7'b1_1_0_0_0_1_0;
        endcase
    end
    
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut_out;

endmodule