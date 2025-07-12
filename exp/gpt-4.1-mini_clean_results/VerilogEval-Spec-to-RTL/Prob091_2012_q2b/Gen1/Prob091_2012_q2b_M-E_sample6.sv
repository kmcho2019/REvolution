module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Intermediate signals to represent states that cause certain transitions
wire from_state_A;
wire from_states_BCEF;

assign from_state_A    = y[0];
assign from_states_BCEF = y[1] | y[2] | y[4] | y[5];

// Next-state input for y[1] flip-flop (state B)
assign Y1 = from_state_A & w;

// Next-state input for y[3] flip-flop (state D)
assign Y3 = (~w) & from_states_BCEF;

endmodule