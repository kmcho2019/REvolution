module TopModule(
    input  [3:0] x,
    output      f
);
    // Karnaugh map mapping:
    // row = x[3:2], column = x[1:0]
    // Don't cares assigned to 0.
    // Truth table vector indexed by x[3:0] as address:
    //  bit#:  15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
    //  value: 0  0  1  1  0  0  1  1  1  0  0  0  0  0  0  0

    localparam [15:0] func_vec = 16'b0000110011100000;

    assign f = func_vec[x];

endmodule