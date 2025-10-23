module TopModule(
    input  [3:0] x,
    output      f
);
    // Variable assignments for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Final simplified expression from corrected K-map interpretation
    assign f = (x3 & x0) | (x3 & x1) | (x1 & x2 & ~x0);

endmodule