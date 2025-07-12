module TopModule(
    input  [5:0] y,   // one-hot current state: A= y[0], B= y[1], C= y[2], D= y[3], E= y[4], F= y[5]
    input        w,
    output       Y2,  // next state's bit for B (y[1])
    output       Y4   // next state's bit for D (y[3])
);

    // Next y[1] (B) is asserted if current state is A (y[0]) and input w=0
    assign Y2 = y[0] & ~w;

    // Next y[3] (D) is asserted if current state is one of B(1), C(2), E(4), F(5) and w=1
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule