module TopModule(
    input  [3:0] x,
    output      f
);
    // Define row and column indices according to the K-map
    // Rows: x[2] (MSB), x[3] (LSB)
    // Cols: x[0] (MSB), x[1] (LSB)
    wire x2 = x[2];
    wire x3 = x[3];
    wire x0 = x[0];
    wire x1 = x[1];
    
    // Implement simplified boolean expression derived from the Karnaugh map:
    // f = (~x2 & ~x3 & ~x1)
    //   | ( x2 &  x3 & (~x0 | x1))
    //   | ( x2 & ~x3 & (~x0 | ~x1))
    assign f = 
          (~x2 & ~x3 & ~x1)
        | ( x2 &  x3 & (~x0 | x1))
        | ( x2 & ~x3 & (~x0 | ~x1));

endmodule