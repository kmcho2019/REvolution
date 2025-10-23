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

    // 7-bit ROM output: [and, or, xor, nand, nor, xnor, anotb]
    reg [6:0] rom_out;

    // ROM implementation as case statement
    always @(*) begin
        case ({a, b})
            2'b00: rom_out = 7'b0001010;
            2'b01: rom_out = 7'b0110100;
            2'b10: rom_out = 7'b1100011;
            2'b11: rom_out = 7'b1011100;
            default: rom_out = 7'bxxxxxxx;
        endcase
    end

    // Output assignments
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = rom_out;

endmodule