module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains the same (optimal single AND gate)
    assign Y1 = y[0] & w;

    // Y3 restructured as balanced OR tree
    wire y1_or_y2 = (y[1] | y[2]) & ~w;
    wire y4_or_y5 = (y[4] | y[5]) & ~w;
    assign Y3 = y1_or_y2 | y4_or_y5;

endmodule