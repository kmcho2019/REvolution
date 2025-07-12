module TopModule (
    input [5:0] y, // current state
    input w,       // input signal
    output Y1,     // input of state flip-flop y[1]
    output Y3      // input of state flip-flop y[3]
);

    // y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F)
    
    // Y1 is 1 when the next state is B
    assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0]) & w; // A to B
    
    // Y3 is 1 when the next state is D
    assign Y3 = ((~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w) | // B to D
                ((~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0]) & ~w) | // C to D
                ((~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w) | // E to D
                ((~y[5] & ~y[4] & y[3] & ~y[2] & y[1] & ~y[0]) & ~w) | // D to D (self-loop)
                (y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0]) & ~w; // F to D

endmodule