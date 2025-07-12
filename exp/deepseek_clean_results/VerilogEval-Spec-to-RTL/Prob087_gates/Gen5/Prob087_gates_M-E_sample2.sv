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

    // 4-entry LUT, each entry contains all 7 outputs in order:
    // [and, or, xor, nand, nor, xnor, anotb]
    reg [6:0] lut [0:3];
    
    initial begin
        // ab = 00
        lut[0] = 7'b0_0_0_1_1_1_0;
        // ab = 01
        lut[1] = 7'b0_1_1_1_0_0_0;
        // ab = 10
        lut[2] = 7'b0_1_1_1_0_0_1;
        // ab = 11
        lut[3] = 7'b1_1_0_0_0_1_0;
    end

    wire [1:0] addr = {a, b};
    wire [6:0] result = lut[addr];
    
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = result;

endmodule