module TopModule(
    input  [5:0] y, // One-hot encoded current state: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    input        w,
    output       Y1, // Next input for y[1] (state B)
    output       Y3  // Next input for y[3] (state D)
);
    // Y1 = y[0] & w
    // Transition A --1--> B means from state A (y[0]) to B (y[1]) on w=1
    assign Y1 = y[0] & w;

    // Y3 = (~w) & (~y[0]) & (~y[3])
    // From the FSM, transitions to state D (y[3]) happen when w=0 and current state is neither A(y[0]) nor D(y[3])
    assign Y3 = (~w) & (~y[0]) & (~y[3]);
endmodule