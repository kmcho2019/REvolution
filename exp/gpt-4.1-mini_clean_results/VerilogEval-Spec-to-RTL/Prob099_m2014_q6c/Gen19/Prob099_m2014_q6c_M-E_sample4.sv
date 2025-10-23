module TopModule (
    input  [5:0] y,  // Current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2, // Next state's B bit (y[1])
    output       Y4  // Next state's D bit (y[3])
);

    // Assign outputs using direct Boolean logic derived from FSM transitions:

    // Y2 is 1 when next state is B, which occurs only from state A (y[0]) on w=0
    assign Y2 = y[0] & ~w;

    // Y4 is 1 when next state is D, which occurs from states B,C,D,E,F (y[1..5]) on w=1
    assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule