module TopModule (
    input  [3:0] x,
    output      f
);

    // Assign x[3:2] and x[1:0] for convenience
    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];

    // Define f based on the Karnaugh map entries
    // The ones correspond to the input combinations:
    // row col = f
    // 00 00 = 1 (x=4'b0000)
    // 00 10 = 1 (x=4'b0010)
    // 11 00 = 1 (x=4'b1100)
    // 11 01 = 1 (x=4'b1101)
    // 11 11 = 1 (x=4'b1111)
    // 10 00 = 1 (x=4'b1000)
    // 10 01 = 1 (x=4'b1001)
    // 10 10 = 1 (x=4'b1010)
    // Other inputs produce 0

    assign f = (x == 4'b0000) ||
               (x == 4'b0010) ||
               (x == 4'b1100) ||
               (x == 4'b1101) ||
               (x == 4'b1111) ||
               (x == 4'b1000) ||
               (x == 4'b1001) ||
               (x == 4'b1010);

endmodule