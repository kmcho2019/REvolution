module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] & ~w) | (y[3] & ~w);  // A->B or D->F transitions
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);  // B/C/E/F->D transitions

endmodule