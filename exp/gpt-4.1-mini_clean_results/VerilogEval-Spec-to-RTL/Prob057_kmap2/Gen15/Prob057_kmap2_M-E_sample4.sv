module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Inputs concatenated as: {c,d,b,a} ? 
    // According to K-map rows: cd, columns: ab
    // The problem statement shows rows as cd, columns as ab, but we need to map inputs accordingly.
    // Let's define the index as: {c,d,b,a}, but careful, the K-map uses cd as row, ab as col.
    // Let's define index = {c,d,b,a} for clarity and verify mapping:

    // Since K-map rows: cd, columns: ab, index = {c,d,b,a} means:
    // c is MSB of row, d is LSB of row, b MSB of col, a LSB of col
    // However, K-map table uses cd as row, ab as column in order: row=cd, col=ab
    // So the proper index = {c,d,b,a} with c=bit3,d=bit2,b=bit1,a=bit0

    wire [3:0] idx = {c,d,b,a};

    // K-map truth table encoded as 16-bit parameter, bit0 corresponds to idx=0 (c=0,d=0,b=0,a=0)
    // Using the K-map given: rows=cd=00..11 top to bottom, cols=ab=00..11 left to right
    // Let's enumerate bits for index 0 to 15 (c,d,b,a):

    // For each combination idx (c,d,b,a), map to K-map value at row=cd, col=ab

    // K-map:
    // cd\ab  00  01  11  10
    // 00     1   1   0   1
    // 01     1   0   0   1
    // 11     0   1   1   1
    // 10     1   1   0   0

    // Indices for row cd, col ab:
    // idx = {c,d,b,a}
    // Index from 0 (0000) to 15 (1111)

    // Map each idx to output:

    // cd=00(0), ab=00(0): idx=0000=0 => 1
    // cd=00, ab=01(1): idx=0001=1 =>1
    // cd=00, ab=11(3): idx=0011=3 =>0
    // cd=00, ab=10(2): idx=0010=2 =>1

    // cd=01(1), ab=00(0): idx=0100=4 =>1
    // cd=01, ab=01(1): idx=0101=5 =>0
    // cd=01, ab=11(3): idx=0111=7 =>0
    // cd=01, ab=10(2): idx=0110=6 =>1

    // cd=11(3), ab=00(0): idx=1100=12 =>0
    // cd=11, ab=01(1): idx=1101=13 =>1
    // cd=11, ab=11(3): idx=1111=15 =>1
    // cd=11, ab=10(2): idx=1110=14 =>1

    // cd=10(2), ab=00(0): idx=1000=8 =>1
    // cd=10, ab=01(1): idx=1001=9 =>1
    // cd=10, ab=11(3): idx=1011=11 =>0
    // cd=10, ab=10(2): idx=1010=10 =>0

    // So bits 15 downto 0: 
    // idx:15-0: (15)1 (14)1 (13)1 (12)0 (11)0 (10)0 (9)1 (8)1 (7)0 (6)1 (5)0 (4)1 (3)0 (2)1 (1)1 (0)1

    // Ordering bits from 15 to 0:
    // bit15=1,14=1,13=1,12=0,11=0,10=0,9=1,8=1,7=0,6=1,5=0,4=1,3=0,2=1,1=1,0=1

    // Bits concatenated: 1110_0011_0101_0111 binary
    // In hex: 0xE357

    localparam [15:0] LUT = 16'hE357;

    assign out = LUT[idx];
endmodule