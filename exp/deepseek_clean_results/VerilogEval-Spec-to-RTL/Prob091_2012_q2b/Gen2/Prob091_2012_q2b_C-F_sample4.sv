module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B) - optimal implementation
    assign Y1 = y[0] & w;

    // Optimized Y3 implementation - factored out ~w for better PPA
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule