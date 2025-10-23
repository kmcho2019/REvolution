module TopModule(
    input [3:0] x,
    output f
);
    assign f = (x[3] & ~x[2] & ~x[1]) |  // Group in top-right corner
               (x[3] & x[1]) |            // Vertical group in middle-right
               (~x[3] & x[2] & x[1]) |   // Small group in 01-11
               (x[3] & ~x[0]);            // Groups in bottom-left and bottom-middle

    // Alternative minimal expression:
    // assign f = (x[3] & ~x[0]) | (x[3] & x[1]) | (~x[3] & x[2] & x[1]);
endmodule