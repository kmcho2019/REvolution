module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire p1, p2;
    wire nand_p1_p2, nor_p1_p2;

    // XOR implemented as (a & ~b) | (~a & b)
    // But here, use direct XOR operator for simplicity in p1 and p2
    assign p1 = a ^ b;
    assign p2 = c ^ d;

    // Use NAND and NOR gates on p1 and p2
    assign nand_p1_p2 = ~(p1 & p2);
    assign nor_p1_p2  = ~(p1 | p2);

    // Combine nand_p1_p2 and nor_p1_p2 to get q matching waveform
    assign q = nand_p1_p2 & nor_p1_p2;

endmodule