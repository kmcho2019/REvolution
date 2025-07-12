module TopModule(
    input  [5:0] y,  // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // Next-state bit Y1 (state B) is 1 when next state is B
    // By inspecting the FSM:
    // Next state B occurs only from state A with input w=0
    assign Y1 = y[0] & ~w;

    // Next-state bit Y3 (state D) is 1 when next state is D
    // Transitions to D occur from:
    // B with w=1: y[1]&w
    // C with w=1: y[2]&w
    // E with w=1: y[4]&w
    // F with w=1: y[5]&w
    // So Y3 = w & (y[1] | y[2] | y[4] | y[5])
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule