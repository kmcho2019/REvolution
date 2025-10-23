module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output        f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Gray to binary conversion for row (x3, x4)
    wire row1 = x3;
    wire row0 = x3 ^ x4;

    // Gray to binary conversion for column (x1, x2)
    wire col1 = x1;
    wire col0 = x1 ^ x2;

    // For readability define binary row and column signals
    wire [1:0] row = {row1, row0};
    wire [1:0] col = {col1, col0};

    // Derive minimized logic from K-map:

    // From the original K-map (row,col):
    // f=1 when:
    // row=11(3): col=00(0), 01(1)
    // row=10(2): col=00(0), 01(1)
    // row=01(1): col=11(3)
    // row=00(0): don't care mostly zero (choose 0)

    // So f = (row == 3 && (col == 0 || col == 1)) ||
    //        (row == 2 && (col == 0 || col == 1)) ||
    //        (row == 1 && col == 3)

    wire row3 = (row == 2'b11);
    wire row2 = (row == 2'b10);
    wire row1_eq = (row == 2'b01);

    wire col0_eq = (col == 2'b00);
    wire col1_eq = (col == 2'b01);
    wire col3_eq = (col == 2'b11);

    assign f = ( (row3 && (col0_eq || col1_eq)) ||
                 (row2 && (col0_eq || col1_eq)) ||
                 (row1_eq && col3_eq) );

endmodule