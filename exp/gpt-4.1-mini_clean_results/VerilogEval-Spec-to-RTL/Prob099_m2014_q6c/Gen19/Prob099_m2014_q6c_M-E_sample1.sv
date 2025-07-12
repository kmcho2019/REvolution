module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for B (y[1])
    output       Y3  // next state bit for D (y[3])
);

    // Next state logic derived from FSM table:
    // Y_next[0] = next A = y[0]&w + y[3]&w
    // Y_next[1] = next B = y[0]&~w
    // Y_next[2] = next C = y[1]&~w + y[5]&~w
    // Y_next[3] = next D = y[1]&w + y[2]&w + y[3]&~w + y[4]&w + y[5]&w
    // Y_next[4] = next E = y[2]&~w + y[4]&~w
    // Y_next[5] = next F = y[3]&~w

    wire [5:0] Y_next;

    assign Y_next[0] = (y[0] & w) | (y[3] & w);
    assign Y_next[1] =  y[0] & ~w;
    assign Y_next[2] = (y[1] & ~w) | (y[5] & ~w);
    assign Y_next[3] = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[4] & w) | (y[5] & w);
    assign Y_next[4] = (y[2] & ~w) | (y[4] & ~w);
    assign Y_next[5] =  y[3] & ~w;

    // Output next state bits corresponding to B and D
    assign Y1 = Y_next[1];
    assign Y3 = Y_next[3];

endmodule