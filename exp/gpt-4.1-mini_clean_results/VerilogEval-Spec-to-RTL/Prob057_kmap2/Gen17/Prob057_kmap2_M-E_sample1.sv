module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Create a 4-bit address: {c,d,b,a}
    wire [3:0] addr = {c,d,b,a};
    
    // 16-bit truth table representing output for inputs 0 to 15:
    // The K-map with input order: cd/ab
    // Address bit order in addr = {c,d,b,a} for indexing
    
    // We need to map each input combination to output:
    // Let's decode the K-map cell by cell:
    // K-map positions:
    // cd\ab: 00 01 11 10
    // 00    1   1   0   1
    // 01    1   0   0   1
    // 11    0   1   1   1
    // 10    1   1   0   0
    //
    // Assign indexes to inputs {c,d,b,a} to bits of the truth table:
    // Inputs: c d b a (bits 3..0)
    // Input decimal = c*8 + d*4 + b*2 + a*1
    //
    // Let's fill bits [15:0] where bit at index = output for that input:
    //
    // Input : c d b a | index | output (from K-map)
    // 0 0 0 0 :  0     | K-map cd=00 ab=00 : 1
    // 0 0 0 1 :  1     | cd=00 ab=01 : 1
    // 0 0 1 0 :  2     | cd=00 ab=10 : 1
    // 0 0 1 1 :  3     | cd=00 ab=11 : 0
    //
    // 0 1 0 0 :  4     | cd=01 ab=00 : 1
    // 0 1 0 1 :  5     | cd=01 ab=01 : 0
    // 0 1 1 0 :  6     | cd=01 ab=10 : 1
    // 0 1 1 1 :  7     | cd=01 ab=11 : 0
    //
    // 1 1 0 0 : 12     | cd=11 ab=00 : 0
    // 1 1 0 1 : 13     | cd=11 ab=01 : 1
    // 1 1 1 0 : 14     | cd=11 ab=10 : 1
    // 1 1 1 1 : 15     | cd=11 ab=11 : 1
    //
    // 1 0 0 0 :  8     | cd=10 ab=00 : 1
    // 1 0 0 1 :  9     | cd=10 ab=01 : 1
    // 1 0 1 0 : 10     | cd=10 ab=10 : 0
    // 1 0 1 1 : 11     | cd=10 ab=11 : 0
    //
    // Rearranged output vector by index from 15 down to 0:
    // idx : val
    // 15:1,14:1,13:1,12:0,
    // 11:0,10:0,9:1,8:1,
    // 7:0,6:1,5:0,4:1,
    // 3:0,2:1,1:1,0:1
    //
    // So bits[15:0] = 16'b 1110_0011_0110_1101
    
    localparam [15:0] LUT = 16'b1110_0011_0110_1101;

    assign out = LUT[addr];

endmodule