module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    // Name input bits for clarity
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray code to binary conversion for row bits (x3, x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray code to binary conversion for column bits (x1, x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Combine to form address for K-map lookup
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Karnaugh map values for each addr index, 1 bit each, 
    // don't-cares set to 0 for simplicity as before
    localparam [15:0] kmap = 16'b0000_0010_1100_1100; 
    // Bit order: addr=0 is LSB, addr=15 is MSB
    // addr:  15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    // value:  0  0  0  0  0  1  1  0  0  1  1  0  0  0  0  0 
    // Matches mapping from previous code

    assign f = kmap[addr];

endmodule