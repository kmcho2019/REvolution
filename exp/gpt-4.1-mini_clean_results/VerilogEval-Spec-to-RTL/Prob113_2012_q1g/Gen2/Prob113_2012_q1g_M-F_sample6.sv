module TopModule(
    input  [3:0] x,
    output       f
);

// x[3]: MSB, x[0]: LSB
// Define each minterm where f=1 according to the Karnaugh map with the correct bit order.
wire m0  = (~x[3]) & (~x[2]) & (~x[1]) & (~x[0]); // 0
wire m2  = (~x[3]) & (~x[2]) & ( x[1]) & (~x[0]); // 2
wire m8  = ( x[3]) & (~x[2]) & (~x[1]) & (~x[0]); // 8
wire m9  = ( x[3]) & (~x[2]) & (~x[1]) & ( x[0]); // 9
wire m10 = ( x[3]) & (~x[2]) & ( x[1]) & (~x[0]); // 10
wire m12 = ( x[3]) & ( x[2]) & (~x[1]) & (~x[0]); // 12
wire m13 = ( x[3]) & ( x[2]) & (~x[1]) & ( x[0]); // 13
wire m15 = ( x[3]) & ( x[2]) & ( x[1]) & ( x[0]); // 15

assign f = m0 | m2 | m8 | m9 | m10 | m12 | m13 | m15;

endmodule