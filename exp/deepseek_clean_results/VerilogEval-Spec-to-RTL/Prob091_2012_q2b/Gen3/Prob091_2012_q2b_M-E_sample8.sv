module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 implementation using MUX-like selection
    assign Y1 = (y[0] & w) |  // From state A
                (y[1] & 1'b0) |  // From state B (0)
                (y[2] & 1'b0) |  // From state C (0)
                (y[3] & 1'b0) |  // From state D (0)
                (y[4] & 1'b0) |  // From state E (0)
                (y[5] & 1'b0);   // From state F (0)

    // Y3 implementation using MUX-like selection
    assign Y3 = (y[0] & 1'b0) |  // From state A (0)
                (y[1] & ~w)   |  // From state B
                (y[2] & ~w)   |  // From state C
                (y[3] & 1'b0) |  // From state D (0)
                (y[4] & ~w)   |  // From state E
                (y[5] & ~w);    // From state F

endmodule