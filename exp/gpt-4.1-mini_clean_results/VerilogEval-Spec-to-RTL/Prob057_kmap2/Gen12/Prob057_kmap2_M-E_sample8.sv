module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Input vector: {a,b,c,d} as address
    wire [3:0] addr = {a,b,c,d};

    // 16-bit truth table representing output for each input combination
    // Index mapping: addr = {a,b,c,d}
    // Map Karnaugh map into truth table bits:
    // From K-map with cd as rows (c,d), ab as columns (a,b):
    // Build truth table ordered by addr:
    // addr  a b c d : out
    // 0 0000 : a=0,b=0,c=0,d=0 -> cd=00 ab=00 = 1
    // 1 0001 : 0 0 0 1 -> cd=01 ab=00 = 1
    // 2 0010 : 0 0 1 0 -> cd=10 ab=00 =1
    // 3 0011 : 0 0 1 1 -> cd=11 ab=00=0
    // 4 0100 : 0 1 0 0 -> cd=00 ab=01=1
    // 5 0101 : 0 1 0 1 -> cd=01 ab=01=0
    // 6 0110 : 0 1 1 0 -> cd=10 ab=01=1
    // 7 0111 : 0 1 1 1 -> cd=11 ab=01=1
    // 8 1000 : 1 0 0 0 -> cd=00 ab=10=1
    // 9 1001 : 1 0 0 1 -> cd=01 ab=10=1
    //10 1010 : 1 0 1 0 -> cd=10 ab=10=0
    //11 1011 : 1 0 1 1 -> cd=11 ab=10=1
    //12 1100 : 1 1 0 0 -> cd=00 ab=11=0
    //13 1101 : 1 1 0 1 -> cd=01 ab=11=0
    //14 1110 : 1 1 1 0 -> cd=10 ab=11=0
    //15 1111 : 1 1 1 1 -> cd=11 ab=11=1
    //
    // Corresponding bits at indexes 15 down to 0 (LSB index 0):
    // bit15=out at addr 15=1
    // bit14=0
    // bit13=0
    // bit12=0
    // bit11=1
    // bit10=0
    // bit9= 1
    // bit8= 1
    // bit7= 1
    // bit6= 1
    // bit5= 0
    // bit4= 1
    // bit3= 0
    // bit2= 1
    // bit1= 1
    // bit0= 1
    //
    // Construct the 16-bit vector accordingly:
    localparam [15:0] LUT = 16'b1001011111010111;

    assign out = LUT[addr];

endmodule