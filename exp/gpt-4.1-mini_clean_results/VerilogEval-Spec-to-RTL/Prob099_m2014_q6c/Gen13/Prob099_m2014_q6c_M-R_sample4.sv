module TopModule (
    input  [5:0] y,  // one-hot current state vector: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state signal for B (y[1])
    output       Y3  // next state signal for D (y[3])
);

    // Y1 (next B) is active only when current state is A (y[0]) and input w=0
    assign Y1 = y[0] & ~w;

    // Y3 (next D) is active when input w=1 and current state is one of B(y[1]), C(y[2]), E(y[4]), or F(y[5])
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule