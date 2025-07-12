module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // Implement the simplified logic expression
    assign f = (x[3] & x[0]) |                     // Row 11 cases
               (x[3] & ~x[0] & ~x[2]) |            // Row 10, column 00
               (x[3] & ~x[0] & ~x[1]) |           // Row 10, column 01
               (~x[3] & x[0] & x[1] & x[2]);       // Row 01, column 11
endmodule