module TopModule (
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next-state signal for B (y[1])
    output       Y4  // next-state signal for D (y[3])
);

    // Y2 = next state B active if currently in A and w=0 (A --0--> B)
    assign Y2 = y[0] & ~w;

    // Y4 = next state D active if:
    //   From B (y[1]) with w=1,
    //   From C (y[2]) with w=1,
    //   From E (y[4]) with w=1,
    //   From F (y[5]) with w=1
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule