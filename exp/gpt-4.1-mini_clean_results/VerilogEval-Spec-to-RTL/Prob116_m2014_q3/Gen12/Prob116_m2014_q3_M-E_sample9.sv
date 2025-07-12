module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);
    // Name bits for clarity
    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    // Implement minimized sum-of-products derived from Karnaugh map
    assign f =
        (x4 &  x3 & ~x2) |   // covers rows 11 columns 00,01 and 10 (partially)
        (x4 & ~x3 & ~x2) |   // covers row 10 col 00,01 (partially)
        (x4 & ~x3 & ~x1) |   // additional terms to cover missing minterms
        (~x4 &  x3 &  x2 &  x1); // covers row 01 col 11 (last 1)

endmodule