module TopModule (
    input [5:0] y, // current state
    input w,       // input signal
    output Y1,     // input of state flip-flop y[1]
    output Y3      // input of state flip-flop y[3]
);

    // y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F)
    assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0]) & w; // next state is B if current state is A and w is 1

    assign Y3 = ((~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w) | // next state is D if current state is B and w is 0
                ((~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0]) & ~w) | // next state is D if current state is C and w is 0
                ((~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w) | // next state is D if current state is E and w is 0
                ((~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0]) & ~w) | // next state is D if current state is D and w is 0
                (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & w; // next state is C if current state is F and w is 1, affecting y[3]

endmodule