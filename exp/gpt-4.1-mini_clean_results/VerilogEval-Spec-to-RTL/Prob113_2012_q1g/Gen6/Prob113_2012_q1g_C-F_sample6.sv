module TopModule(
    input  [3:0] x,
    output       f
);
    // Input bit mapping to Karnaugh map:
    // Rows indexed by x[2] (MSB), x[3] (LSB)
    // Columns indexed by x[0] (MSB), x[1] (LSB)
    //
    // Address for LUT = {row bits, column bits} = {x[2], x[3], x[0], x[1]}
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    // LUT encodes function values f for addr=0..15:
    // From Karnaugh map (bit0=addr0=0000, bit15=addr15=1111):
    // bit15=1, bit14=0, bit13=1, bit12=1, bit11=0, bit10=1, bit9=1, bit8=1,
    // bit7=0, bit6=0, bit5=0, bit4=0, bit3=0, bit2=1, bit1=0, bit0=1
    localparam [15:0] LUT = 16'b1011011100000101;

    assign f = LUT[addr];
endmodule