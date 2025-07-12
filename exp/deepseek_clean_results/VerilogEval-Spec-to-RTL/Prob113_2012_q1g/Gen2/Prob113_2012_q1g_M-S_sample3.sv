module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[1] & ~x[0]) |       // Covers 0000,0010,1000,1010
               (x[3] & x[2]) |         // Covers 1100,1101,1111
               (x[3] & ~x[2] & x[0]);  // Covers 1001,1011
endmodule