module TopModule(
    input  [3:0] x,
    output      f
);
    // Define a 16-bit constant lookup table representing f for each possible x.
    // Indexing: f_lut[x] gives output f for input x.
    // According to the K-map and indexing:
    // x[3]x[2]x[1]x[0] = input bits from MSB to LSB
    // The given Karnaugh map and bit ordering implies we can directly place values.
    // We'll build f_lut with bit positions matching x from 0 to 15.

    localparam [15:0] f_lut = 16'b1111101111110001;
    // Explanation of f_lut bits (bit index = input x as decimal):
    // x=0  (0000) -> row 00, col 00: 1
    // x=1  (0001) -> row 00, col 01: 0
    // x=2  (0010) -> row 00, col 10: 1
    // x=3  (0011) -> row 00, col 11: 0
    // x=4  (0100) -> row 01, col 00: 0
    // x=5  (0101) -> row 01, col 01: 0
    // x=6  (0110) -> row 01, col 10: 0
    // x=7  (0111) -> row 01, col 11: 0
    // x=8  (1000) -> row 10, col 00: 1
    // x=9  (1001) -> row 10, col 01: 1
    // x=10 (1010) -> row 10, col 10: 1
    // x=11 (1011) -> row 10, col 11: 0
    // x=12 (1100) -> row 11, col 00: 1
    // x=13 (1101) -> row 11, col 01: 1
    // x=14 (1110) -> row 11, col 10: 0
    // x=15 (1111) -> row 11, col 11: 1

    assign f = f_lut[x];

endmodule