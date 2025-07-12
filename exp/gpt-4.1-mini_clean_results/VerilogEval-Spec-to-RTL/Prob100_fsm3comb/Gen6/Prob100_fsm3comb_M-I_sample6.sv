module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    wire S1 = state[1];
    wire S0 = state[0];
    wire I  = in;

    // next_state[1] logic derived from boolean equations
    assign next_state[1] = (~S1 & S0 & ~I) | (S1 & ~S0 & I) | (S1 & S0 & ~I);

    // next_state[0] directly follows input
    assign next_state[0] = I;

    // output is 1 only when in state D (2'b11)
    assign out = S1 & S0;

endmodule