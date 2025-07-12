module TopModule(
    input [3:0] x,  // x[3:2] are row bits, x[1:0] are column bits
    output f
);
    assign f = x[3] |                         // Covers rows 3 and 4 (with don't-care optimizations)
               (x[2] & x[1] & x[0]) |        // Row 2, column 11
               (~x[3] & x[2] & ~x[1]);       // Row 4, columns 00 and 01 (since x[3]=1 covers row 3)
endmodule