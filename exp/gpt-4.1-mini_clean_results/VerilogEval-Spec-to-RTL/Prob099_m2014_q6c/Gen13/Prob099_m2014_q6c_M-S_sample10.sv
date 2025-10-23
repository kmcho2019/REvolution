module TopModule(
    input  [5:0] y,  // current one-hot state: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // From the FSM transitions:
    // Y1 (B) is next when:
    //   From A (y[0]) with w=0 => next B
    //   From no other state leads directly to B
    assign Y1 = y[0] & ~w;

    // Y3 (D) is next when:
    //   From B (y[1]) with w=1 => D
    //   From C (y[2]) with w=1 => D
    //   From E (y[4]) with w=1 => D
    //   From F (y[5]) with w=1 => D
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule