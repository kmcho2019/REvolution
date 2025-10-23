module TopModule(
    input [3:0] x,
    output f
);
    // Direct implementation of K-map using optimized Boolean expressions
    assign f = (~x[3] & ~x[2] & ~x[1] & ~x[0]) |  // 0000
               (~x[3] & ~x[2] & x[1] & ~x[0])  |  // 0010
               (x[3] & ~x[2] & ~x[1] & ~x[0])  |  // 1000
               (x[3] & ~x[2] & ~x[1] & x[0])   |  // 1001
               (x[3] & ~x[2] & x[1] & ~x[0])   |  // 1010
               (x[3] & x[2] & ~x[1] & ~x[0])   |  // 1100
               (x[3] & x[2] & ~x[1] & x[0])    |  // 1101
               (x[3] & x[2] & x[1] & x[0]);      // 1111

    // Alternative implementation using row/column decoding (more readable)
    /*
    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];
    
    assign f = (row == 2'b00) ? ((col == 2'b00) | (col == 2'b10)) :
               (row == 2'b11) ? ((col != 2'b10)) :
               (row == 2'b10) ? ((col != 2'b11)) :
               1'b0;
    */
endmodule