module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains optimal as is - only one condition
    assign Y1 = y[0] & w;

    // Optimized Y3 by factoring out ~w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule