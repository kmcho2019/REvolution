module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains the same - most straightforward implementation
    assign Y1 = y[0] & w;

    // Y3 optimized by factoring out ~w and combining state bits
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule