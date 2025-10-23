module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Inputs as a 4-bit index: {c,d,b,a} or {d,c,b,a}
    // Based on problem statement, table rows are cd, columns ab.
    // So inputs order for indexing should be: {c,d,b,a} or {d,c,b,a}?
    // K-map rows = cd (00,01,11,10)
    // columns = ab (00,01,11,10)
    // Index bits from MSB to LSB = cdab = {c,d,b,a}
    // But c and d are row bits, a and b are column bits, so index = {c,d,a,b} to match K-map.

    // To match the table, index = {c,d,a,b} 
    wire [3:0] idx = {c,d,a,b};

    // K-map outputs encoded as 16-bit value, where bit position is index:
    // Bit 0 = c=0,d=0,a=0,b=0 (row=00 col=00)
    // From K-map:
    // cd\ab 00 01 11 10
    // 00 |1 |1 |0 |1 |
    // 01 |1 |0 |0 |1 |
    // 11 |0 |1 |1 |1 |
    // 10 |1 |1 |0 |0 |

    // Let's map bits assuming idx = c d a b:
    // c d a b : output
    // 0 0 0 0 : 1 (bit 0)
    // 0 0 0 1 : 1 (bit 1)
    // 0 0 1 1 : 0 (bit 3)
    // 0 0 1 0 : 1 (bit 2)
    // 0 1 0 0 : 1 (bit 4)
    // 0 1 0 1 : 0 (bit 5)
    // 0 1 1 1 : 0 (bit 7)
    // 0 1 1 0 : 1 (bit 6)
    // 1 1 0 0 : 0 (bit 12)
    // 1 1 0 1 : 1 (bit 13)
    // 1 1 1 1 : 1 (bit 15)
    // 1 1 1 0 : 1 (bit 14)
    // 1 0 0 0 : 1 (bit 8)
    // 1 0 0 1 : 1 (bit 9)
    // 1 0 1 1 : 0 (bit 11)
    // 1 0 1 0 : 0 (bit 10)

    // Let's write bits 15 to 0:
    // bit: val
    // 15:1
    // 14:1
    // 13:1
    // 12:0
    // 11:0
    // 10:0
    // 9 :1
    // 8 :1
    // 7 :0
    // 6 :1
    // 5 :0
    // 4 :1
    // 3 :0
    // 2 :1
    // 1 :1
    // 0 :1

    // Binary from bit15 to bit0: 1110_0011_0100_1011
    // Which is 16'hE34B

    localparam [15:0] LUT = 16'hE34B;

    assign out = LUT[idx];

endmodule