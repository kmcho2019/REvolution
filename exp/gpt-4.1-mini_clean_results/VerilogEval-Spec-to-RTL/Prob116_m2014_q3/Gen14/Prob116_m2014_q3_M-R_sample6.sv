module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Assign named input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray-to-binary conversion for row bits (x3,x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray-to-binary conversion for column bits (x1,x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Flattened 4-bit address {row_bin1,row_bin0,col_bin1,col_bin0}
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // LUT encoding f values for addr = 4'b0000..4'b1111, per K-map:
    // Index bit: addr value, bit[addr] = f
    // Use 'd' = 0 as default for simplicity
    // Bits: [15:0] = f for addr=0..15
    // According to previous mapping (bit0 = addr=0):
    // addr: f
    // 0000:0, 0001:0, 0010:0, 0011:0,
    // 0100:0, 0101:0, 0110:1, 0111:0,
    // 1000:1, 1001:1, 1010:0, 1011:0,
    // 1100:1, 1101:1, 1110:0, 1111:0
    // Binary LUT = 16'b0000110011000110 reversed for indexing (addr as index)
    // We'll write bits in order [15:0] = addr=15 downto 0:
    // addr=15(0),14(0),13(1),12(1),11(0),10(0),9(1),8(1),
    // 7(0),6(1),5(0),4(0),3(0),2(0),1(0),0(0)
    // So LUT = 16'b0011001100100000
    localparam [15:0] LUT = 16'b0011001100100000;

    assign f = LUT[addr];

endmodule