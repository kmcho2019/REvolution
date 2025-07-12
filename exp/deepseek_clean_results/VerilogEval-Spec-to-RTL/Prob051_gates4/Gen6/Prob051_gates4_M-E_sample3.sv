module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Pre-computed truth tables for all 16 possible inputs
    reg [2:0] lut [0:15];
    
    // Initialize LUT with all possible combinations
    initial begin
        lut[0]  = 3'b000; // 0000
        lut[1]  = 3'b010; // 0001
        lut[2]  = 3'b010; // 0010
        lut[3]  = 3'b011; // 0011
        lut[4]  = 3'b010; // 0100
        lut[5]  = 3'b011; // 0101
        lut[6]  = 3'b011; // 0110
        lut[7]  = 3'b111; // 0111
        lut[8]  = 3'b010; // 1000
        lut[9]  = 3'b011; // 1001
        lut[10] = 3'b011; // 1010
        lut[11] = 3'b111; // 1011
        lut[12] = 3'b011; // 1100
        lut[13] = 3'b111; // 1101
        lut[14] = 3'b111; // 1110
        lut[15] = 3'b111; // 1111
    end

    // Output assignments from LUT
    assign {out_xor, out_or, out_and} = lut[in];

endmodule