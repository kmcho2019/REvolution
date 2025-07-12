module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Truth table parameter for f indexed by Gray-coded input x = {x4,x3,x2,x1}
    // Bit index: x[3:0], MSB is x4, LSB is x1
    // Assign don't-cares as 0
    // Mapping from K-map rows x4x3 and columns x2x1 in Gray order:
    // Row x4x3: 00,01,11,10 (indexes 0,1,3,2 decimal)
    // Column x2x1: 00,01,11,10 (indexes 0,1,3,2 decimal)
    //
    // To map: f = LUT[x4x3x2x1] where x4x3 and x2x1 are Gray code bits.
    //
    // From given K-map: (rows by x4x3; cols by x2x1)
    // 00 00 = d(0), 00 01=0, 00 11=d(0), 00 10=d(0)
    // 01 00=0, 01 01=d(0), 01 11=1, 01 10=0
    // 11 00=1, 11 01=1, 11 11=d(0), 11 10=d(0)
    // 10 00=1, 10 01=1, 10 11=0, 10 10=d(0)
    //
    // Index order: x4 x3 x2 x1 (MSB to LSB) as input bitvector
    // We write the bitstring f_table with LSB = address 0.
    //
    // Construct f_table (bit 0 is addr=0=0000 x4=0 x3=0 x2=0 x1=0):
    // addr: f
    // 0b0000=0000=d=0
    // 0b0001=0001=0
    // 0b0010=0010=d=0
    // 0b0011=0011=d=0
    // 0b0100=0100=0
    // 0b0101=0101=d=0
    // 0b0110=0110=1
    // 0b0111=0111=0
    // 0b1000=1000=1
    // 0b1001=1001=1
    // 0b1010=1010=0
    // 0b1011=1011=d=0
    // 0b1100=1100=1
    // 0b1101=1101=1
    // 0b1110=1110=0
    // 0b1111=1111=d=0

    localparam [15:0] f_table = 16'b0110001001100000;

    assign f = f_table[x];

endmodule