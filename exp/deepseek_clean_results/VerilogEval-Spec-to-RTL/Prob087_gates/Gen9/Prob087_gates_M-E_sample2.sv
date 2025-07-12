module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);

    // Packed array where each entry contains all 7 outputs in order:
    // [and, or, xor, nand, nor, xnor, anotb]
    reg [6:0] lut [0:3];
    
    initial begin
        // Initialize LUT with all possible output combinations
        lut[2'b00] = 7'b0001101; // a=0, b=0
        lut[2'b01] = 7'b0110010; // a=0, b=1
        lut[2'b10] = 7'b1011011; // a=1, b=0
        lut[2'b11] = 7'b1100100; // a=1, b=1
    end

    // Output the appropriate bits from the LUT
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = lut[{a,b}];

endmodule