// Define a small, pre-computed comparison LUT module
module ComparisonLUT(
    input [4:0] inputs,
    output [24:0] out
);
    // Pre-computed LUT for all possible input combinations
    reg [24:0] lut [2**5-1:0];

    always @(inputs) begin
        // Initialize LUT with pre-computed values
        lut[0] = 25'b1; // 00000: all equal
        lut[1] = 25'b11011011101110110111; // 00001: a!=e, b!=e, c!=e, d!=e
        lut[2] = 25'b1101110111011011101; // 00010: a!=d, b!=d, c!=d, e!=d
        lut[3] = 25'b1110111011101110111; // 00011: a!=c, b!=c, d!=c, e!=c
        lut[4] = 25'b1011101110111011110; // 00100: a!=b, c!=b, d!=b, e!=b
        lut[5] = 25'b1010111011101111011; // 00101: a!=e, b!=e, c!=e, d!=e
        lut[6] = 25'b1011110111011101101; // 00110: a!=d, b!=d, c!=d, e!=d
        lut[7] = 25'b1101110111011101111; // 00111: a!=c, b!=c, d!=c, e!=c
        lut[8] = 25'b0111101110111011110; // 01000: a!=b, c!=b, d!=b, e!=b
        lut[9] = 25'b0110111011101111011; // 01001: a!=e, b!=e, c!=e, d!=e
        lut[10] = 25'b0111110111011101101; // 01010: a!=d, b!=d, c!=d, e!=d
        lut[11] = 25'b1001110111011101111; // 01011: a!=c, b!=c, d!=c, e!=c
        lut[12] = 25'b0011101110111011110; // 01100: a!=b, c!=b, d!=b, e!=b
        lut[13] = 25'b0010111011101111011; // 01101: a!=e, b!=e, c!=e, d!=e
        lut[14] = 25'b0011110111011101101; // 01110: a!=d, b!=d, c!=d, e!=d
        lut[15] = 25'b0101110111011101111; // 01111: a!=c, b!=c, d!=c, e!=c
        lut[16] = 25'b0001101110111011110; // 10000: a!=b, c!=b, d!=b, e!=b
        lut[17] = 25'b0000111011101111011; // 10001: a!=e, b!=e, c!=e, d!=e
        lut[18] = 25'b0001110111011101101; // 10010: a!=d, b!=d, c!=d, e!=d
        lut[19] = 25'b1000111011101111111; // 10011: a!=c, b!=c, d!=c, e!=c
        lut[20] = 25'b1001101110111011110; // 10100: a!=b, c!=b, d!=b, e!=b
        lut[21] = 25'b1000111011101111011; // 10101: a!=e, b!=e, c!=e, d!=e
        lut[22] = 25'b1001110111011101101; // 10110: a!=d, b!=d, c!=d, e!=d
        lut[23] = 25'b1100111011101111111; // 10111: a!=c, b!=c, d!=c, e!=c
        lut[24] = 25'b1101101110111011110; // 11000: a!=b, c!=b, d!=b, e!=b
        lut[25] = 25'b1100111011101111011; // 11001: a!=e, b!=e, c!=e, d!=e
        lut[26] = 25'b1101110111011101101; // 11010: a!=d, b!=d, c!=d, e!=d
        lut[27] = 25'b1110111011101111111; // 11011: a!=c, b!=c, d!=c, e!=c
        lut[28] = 25'b1111101110111011110; // 11100: a!=b, c!=b, d!=b, e!=b
        lut[29] = 25'b1110111011101111011; // 11101: a!=e, b!=e, c!=e, d!=e
        lut[30] = 25'b1111110111011101101; // 11110: a!=d, b!=d, c!=d, e!=d
        lut[31] = 25'b1111111111111111111; // 11111: all equal

        // Select output from LUT based on input combination
        out = lut[inputs];
    end
endmodule

// TopModule utilizing the ComparisonLUT module
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Define input array
    wire [4:0] inputs = {a, b, c, d, e};

    // Instantiate ComparisonLUT module
    ComparisonLUT clut(inputs, out);

endmodule