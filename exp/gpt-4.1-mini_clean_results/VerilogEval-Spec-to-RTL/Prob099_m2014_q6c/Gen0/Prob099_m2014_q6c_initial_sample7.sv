module TopModule (
    input  [5:0] y, // one-hot current state vector: A=y[0],B=y[1],C=y[2],D=y[3],E=y[4],F=y[5]
    input        w,
    output       Y1, // next state bit corresponding to y[1] (B)
    output       Y3  // next state bit corresponding to y[3] (D)
);

    // Next state for B (y[1]) is active if current state is A and w=0
    assign Y1 = y[0] & ~w;

    // Next state for D (y[3]) is active if current state is B,C,E or F and w=1
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule