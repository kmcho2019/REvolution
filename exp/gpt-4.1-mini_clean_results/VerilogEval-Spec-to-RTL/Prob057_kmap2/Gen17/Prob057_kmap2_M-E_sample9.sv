module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Create a 16-entry wire array representing the ROM content indexed by {c,d,b,a} or any order
    // Let's define the address as {c,d,b,a} to map to the K-map as given
    wire [15:0] rom = 16'b1101101101110011;
    // Explanation:
    // Index  c d b a (bits order)
    // 0: 0 0 0 0 -> K-map cd=00 ab=00 => 1 (bit0)
    // 1: 0 0 0 1 -> cd=00 ab=01 => 1
    // 2: 0 0 1 0 -> cd=00 ab=10 => 1
    // 3: 0 0 1 1 -> cd=00 ab=11 => 0
    // 4: 0 1 0 0 -> cd=01 ab=00 => 1
    // 5: 0 1 0 1 -> cd=01 ab=01 => 0
    // 6: 0 1 1 0 -> cd=01 ab=10 => 1
    // 7: 0 1 1 1 -> cd=01 ab=11 => 0
    // 8: 1 1 0 0 -> cd=11 ab=00 => 0
    // 9: 1 1 0 1 -> cd=11 ab=01 => 1
    //10: 1 1 1 0 -> cd=11 ab=10 => 1
    //11: 1 1 1 1 -> cd=11 ab=11 => 1
    //12: 1 0 0 0 -> cd=10 ab=00 => 1
    //13: 1 0 0 1 -> cd=10 ab=01 => 1
    //14: 1 0 1 0 -> cd=10 ab=10 => 0
    //15: 1 0 1 1 -> cd=10 ab=11 => 0

    wire [3:0] addr = {c, d, b, a};
    assign out = rom[addr];
endmodule