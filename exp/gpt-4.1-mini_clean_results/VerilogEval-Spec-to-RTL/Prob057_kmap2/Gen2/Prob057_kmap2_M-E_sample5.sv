module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inputs combined into a 4-bit address: {c,d,a,b}
    wire [3:0] addr = {c,d,a,b};

    // ROM content encoding the K-map:
    // Mapping cell (cd,ab) with ab as LSBs is:
    // addr = c d a b, bit position = addr decimal
    // K-map from problem mapped to bits:
    // 0000 = 1, 0001 = 1, 0010 = 1, 0011 = 0,
    // 0100 = 1, 0101 = 0, 0110 = 1, 0111 = 0,
    // 1000 = 1, 1001 = 1, 1010 = 0, 1011 = 0,
    // 1100 = 0, 1101 = 1, 1110 = 1, 1111 = 1
    // bits ordered as addr from 0 to 15:
    //  15   14   13   12   11   10    9    8    7    6    5    4    3    2    1    0
    //  b15  b14  b13  b12  b11  b10  b9   b8   b7   b6   b5   b4   b3   b2   b1   b0
    //  1    1    1    0    0    0    1    1    0    1    0    1    0    1    1    1
    // Reordered carefully to match address:
    localparam [15:0] LUT = 16'b1110001101010101;

    assign out = LUT[addr];

endmodule