module TopModule(
    input  [5:0] y, // one-hot encoded current state: A= y[0], B= y[1], C= y[2], D= y[3], E= y[4], F= y[5]
    input        w,
    output       Y2, // next state bit corresponding to y[1]
    output       Y4  // next state bit corresponding to y[3]
);

//
// From the transition table and one-hot states:
//
// States:
// y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F
//
// Next states that set y[1] (B):
// - A(0) --0--> B: if (y[0] & ~w) then next = B (y[1])
//
// Next states that set y[3] (D):
// - B(0) --1--> D: y[1] & ~w? No, w=1 here, so y[1] & w
// - C(0) --1--> D: y[2] & w
// - D(0) --1--> A(doesn't set y[3])
// - E(1) --1--> D: y[4] & w
// - F(1) --1--> D: y[5] & w
//
// So Y2 = next y[1] bit = y[0] & ~w
//
// Y4 = next y[3] bit = w & (y[1] | y[2] | y[4] | y[5])
//

assign Y2 = y[0] & ~w;
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule