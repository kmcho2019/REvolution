module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Shared inverted w signal for power optimization
    wire w_n;
    assign w_n = ~w;

    // Optimal Y1 implementation
    assign Y1 = y[0] & w;

    // Optimized Y3 implementation using one-hot property
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w_n;

endmodule