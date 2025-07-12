module TopModule (
    input  [3:0] x,  // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output        f
);

    // Map input bits explicitly for clarity
    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Gray-to-binary conversion for row (x3,x4)
    wire row_bin1 = x3;
    wire row_bin0 = x3 ^ x4;

    // Gray-to-binary conversion for column (x1,x2)
    wire col_bin1 = x1;
    wire col_bin0 = x1 ^ x2;

    // Form flat 4-bit address: {row_bin1, row_bin0, col_bin1, col_bin0}
    wire [3:0] addr = {row_bin1, row_bin0, col_bin1, col_bin0};

    // Define a 16-bit constant representing the output f for each addr value.
    // Each bit corresponds to f at that addr index.
    // From original mapping (d treated as 0):
    // addr: f
    // 0000:0, 0001:0, 0010:0, 0011:0,
    // 0100:0, 0101:0, 0110:1, 0111:0,
    // 1000:1, 1001:1, 1010:0, 1011:0,
    // 1100:1, 1101:1, 1110:0, 1111:0
    localparam [15:0] F_TABLE = 16'b0011001111000000; // bit0=addr0

    assign f = F_TABLE[addr];

endmodule