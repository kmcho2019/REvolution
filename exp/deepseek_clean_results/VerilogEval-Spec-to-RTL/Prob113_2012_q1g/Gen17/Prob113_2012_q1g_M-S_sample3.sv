module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & (~x[1] | ~x[0])) |  // First case
               (x[3] & x[2] & ~x[1]) |             // Second case
               (x[3] & ~x[2] & (x[0] | ~x[1]));    // Third case
endmodule