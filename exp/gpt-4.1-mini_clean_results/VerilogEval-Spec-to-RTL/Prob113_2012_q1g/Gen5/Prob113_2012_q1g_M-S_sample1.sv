module TopModule(
    input  [3:0] x,
    output       f
);
    assign f =
        (~x[3] & ~x[2] & ~x[1] & ~x[0]) | // row 00, col 00
        (~x[3] & ~x[2] &  x[1] & ~x[0]) | // row 00, col 10
        (~x[3] &  x[2] &  x[1] &  x[0]) | // row 11, col 11
        (~x[3] &  x[2] &  x[1] & ~x[0]) | // row 11, col 10
        (~x[3] &  x[2] & ~x[1] & ~x[0]) | // row 11, col 00
         (x[3] & ~x[2] &  x[1] &  x[0]) | // row 10, col 11
         (x[3] & ~x[2] &  x[1] & ~x[0]) | // row 10, col 10
         (x[3] & ~x[2] & ~x[1] &  x[0]);  // row 10, col 01
endmodule