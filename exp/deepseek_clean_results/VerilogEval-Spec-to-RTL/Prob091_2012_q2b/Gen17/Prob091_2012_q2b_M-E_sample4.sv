module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is next state for y[1] (B) - only from A when w=1
    assign Y1 = y[0] & w;

    // Y3 is next state for y[3] (D) - from multiple states when w=0
    assign Y3 = (~w) & (
                y[1] |  // From B
                y[2] |  // From C
                y[4] |  // From E
                y[5]    // From F
                );

endmodule