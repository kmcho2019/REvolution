module TopModule (
    input [5:0] y, // current state
    input w,       // input signal
    output Y1,     // input of state flip-flop y[1]
    output Y3      // input of state flip-flop y[3]
);

    // Determine next state logic for Y1 (y[1] = 1 when next state is B)
    assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & w) | // A to B
                (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w & y[5]'b0) | // Any state to B when w=1 and not A
                (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w); // D to B

    // Determine next state logic for Y3 (y[3] = 1 when next state is D)
    assign Y3 = (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | // B to D
                (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | // C to D
                (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w) | // E to D
                (~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0] & ~w) | // D to D (self-loop)
                (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & ~w); // F to D

endmodule