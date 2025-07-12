module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 represents the input to state B flip-flop
    assign Y1 = y[0] & w;  // A->B transition when w=1

    // Y3 represents the input to state D flip-flop
    assign Y3 = (y[1] & ~w) |  // B->D when w=0
                (y[2] & ~w) |  // C->D when w=0
                (y[5] & ~w);    // F->D when w=0

endmodule