module TopModule(
    input  [3:0] x,
    output      f
);
    // 16-bit ROM: bit position corresponds to x[3:0] value (0 to 15)
    // The value at each position corresponds to the function f for that input
    // From Karnaugh map:
    // Inputs (x3x2x1x0):
    // 0: 0000 -> 1
    // 1: 0001 -> 0
    // 2: 0010 -> 1
    // 3: 0011 -> 0
    // 4: 0100 -> 0
    // 5: 0101 -> 0
    // 6: 0110 -> 0
    // 7: 0111 -> 0
    // 8: 1000 -> 1
    // 9: 1001 -> 1
    // 10:1010 -> 0
    // 11:1011 -> 1
    // 12:1100 -> 0
    // 13:1101 -> 1
    // 14:1110 -> 1
    // 15:1111 -> 1

    // We'll store values in the order x as index:
    // bit 0 = f(0000) = 1
    // bit 1 = f(0001) = 0
    // bit 2 = f(0010) = 1
    // bit 3 = f(0011) = 0
    // bit 4 = f(0100) = 0
    // bit 5 = f(0101) = 0
    // bit 6 = f(0110) = 0
    // bit 7 = f(0111) = 0
    // bit 8 = f(1000) = 1
    // bit 9 = f(1001) = 1
    // bit 10= f(1010) = 0
    // bit 11= f(1011) = 1
    // bit 12= f(1100) = 0
    // bit 13= f(1101) = 1
    // bit 14= f(1110) = 1
    // bit 15= f(1111) = 1

    localparam [15:0] ROM = 16'b1111011000001011;

    assign f = ROM[x];

endmodule