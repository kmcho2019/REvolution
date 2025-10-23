module TopModule(
    input [3:0] x,
    output f
);
    assign f = (~x[3] & ~x[2] & ~x[1]) |  // First group
               (x[3] & x[2] & ~x[1])   |  // Second group
               (x[3] & x[2] & ~x[0])   |  // Third group
               (x[3] & x[1] & ~x[0]);     // Fourth group
endmodule