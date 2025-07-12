module TopModule(
    input  [3:0] x,
    output       f
);

    // Karnaugh map indexing:
    // Rows: x[2] (MSB), x[3] (LSB)
    // Columns: x[0] (MSB), x[1] (LSB)
    //
    // Construct 4-bit address for LUT indexing as:
    // addr = {x[2], x[3], x[0], x[1]}
    //
    // LUT bit order:
    // bit 0  -> addr = 4'b0000 -> f when x={x[3],x[2],x[1],x[0]} = ?
    // bit 15 -> addr = 4'b1111
    //
    // LUT content (from Karnaugh map):
    // bit15=1, bit14=0, bit13=1, bit12=1, bit11=0, bit10=1, bit9=1, bit8=1,
    // bit7=0, bit6=0, bit5=0, bit4=0, bit3=0, bit2=1, bit1=0, bit0=1
    localparam [15:0] LUT = 16'b1011011100000101;

    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    assign f = LUT[addr];

endmodule