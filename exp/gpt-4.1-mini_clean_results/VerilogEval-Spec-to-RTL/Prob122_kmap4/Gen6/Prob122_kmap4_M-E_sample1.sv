module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Construct 4-bit index from inputs: abcd
    wire [3:0] idx = {a, b, c, d};

    // 16-bit vector representing the K-map outputs for all input combinations
    // Indexed by: abcd as a binary number (MSB=a)
    // The bits are arranged so that bit 0 corresponds to input 0000,
    // bit 1 to 0001, ..., bit 15 to 1111
    // Mapping from the problem's table (cd,ab):
    // Inputs -> output: 
    // 0000 -> 0, 0001 -> 1, 0011 -> 0, 0010 -> 1
    // 0100 -> 1, 0101 -> 0, 0111 -> 1, 0110 -> 0
    // 1100 -> 0, 1101 -> 1, 1111 -> 0, 1110 -> 1
    // 1000 -> 1, 1001 -> 0, 1011 -> 1, 1010 -> 0
    // Putting them all in order from 0000 to 1111:
    // Index: value
    // 0000(0):0
    // 0001(1):1
    // 0010(2):1  <- careful: inputs c=1,d=0 => 10 for cd, ab=00 for a=0,b=0 so ab=00 cd=10 means input 0010 (a=0,b=0,c=1,d=0)
    // 0011(3):0
    // 0100(4):1
    // 0101(5):0
    // 0110(6):0
    // 0111(7):1
    // 1000(8):1
    // 1001(9):0
    // 1010(10):0
    // 1011(11):1
    // 1100(12):0
    // 1101(13):1
    // 1110(14):1
    // 1111(15):0
    // Final vector bits (bit 15 down to bit 0):
    // Index: output
    // 15:0
    // 14:1
    // 13:1
    // 12:0
    // 11:1
    // 10:0
    // 9:0
    // 8:1
    // 7:1
    // 6:0
    // 5:0
    // 4:1
    // 3:0
    // 2:1
    // 1:1
    // 0:0
    // Binary: 0b0_1_1_0_1_0_0_1_1_0_0_1_0_1_1_0
    // Hex: 0b0110100110010110 = 16'h6996 (check carefully)
    localparam [15:0] LUT = 16'h6996;

    assign out = LUT[idx];
endmodule