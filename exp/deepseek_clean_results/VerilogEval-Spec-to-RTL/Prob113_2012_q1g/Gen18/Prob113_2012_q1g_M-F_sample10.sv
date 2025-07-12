module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1]) |          // First case (00-00 and 00-10)
               (x[3] & x[2] & ~(x[1] & ~x[0])) |  // Second case (11-00,11-01,11-11)
               (x[3] & ~x[2] & ~(x[1] & x[0]));    // Third case (10-00,10-01,10-10)
endmodule