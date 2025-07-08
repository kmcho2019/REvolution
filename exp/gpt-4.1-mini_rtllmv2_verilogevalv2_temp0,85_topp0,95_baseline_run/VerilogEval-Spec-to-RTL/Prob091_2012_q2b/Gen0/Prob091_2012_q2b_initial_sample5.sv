module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 = input to flip-flop y[1] (state B)
// From FSM: A (y[0]) with w=1 transitions to B
assign Y1 = y[0] & w;

// Y3 = input to flip-flop y[3] (state D)
// From FSM: B, C, E, F (y[1], y[2], y[4], y[5]) with w=0 transitions to D
assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule