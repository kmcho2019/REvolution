module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // State transition matrix approach
    wire next_B = (y[0] & w) | (y[5] & w);  // A->B or F->B when w=1
    wire next_D = (y[1] & ~w) |              // B->D when w=0
                  (y[2] & ~w) |              // C->D when w=0
                  (y[4] & ~w) |              // E->D when w=0
                  (y[5] & ~w);               // F->D when w=0

    assign Y1 = next_B;    // y[1] input is next_B
    assign Y3 = next_D;    // y[3] input is next_D

endmodule