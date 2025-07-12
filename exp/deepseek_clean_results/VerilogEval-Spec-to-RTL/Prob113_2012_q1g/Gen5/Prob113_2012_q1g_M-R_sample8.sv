module TopModule(
    input [3:0] x,
    output f
);
    // Implement the K-map directly using pattern matching
    assign f = (~x[3] & ~x[2] & ((~x[1] & ~x[0]) | (x[1] & ~x[0]))) |  // row00: 00 or 10
               (~x[3] & x[2] & 1'b0) |                                // row01: always 0
               (x[3] & x[2] & ~(~x[1] & x[0])) |                       // row11: not 10
               (x[3] & ~x[2] & ~(x[1] & x[0]));                       // row10: not 11

    // Alternative implementation using case-like structure
    /*
    wire [1:0] row = x[3:2];
    wire [1:0] col = x[1:0];
    
    assign f = (row == 2'b00) ? ((col == 2'b00) | (col == 2'b10)) :
               (row == 2'b01) ? 1'b0 :
               (row == 2'b11) ? (col != 2'b10) :
               (row == 2'b10) ? (col != 2'b11) :
               1'b0;
    */
endmodule