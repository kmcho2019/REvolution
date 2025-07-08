module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    input        w,
    output       Y1, // next-state bit y[1]
    output       Y3  // next-state bit y[3]
);

// states encoding for clarity (not used in code, just reference):
// A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

// Next state logic by inspection:

// Y1 corresponds to next state's y[1] (B)
// Which current states and w values lead to next state B?

// From transitions:
// A (y[0]) --0--> B (y[1])
// So if y[0] and w=0 => next y[1]=1

// No other transitions lead to B.

// So:
// Y1 = y[0] & (~w)

// Y3 corresponds to next state's y[3] (D)
// From transitions to D:
// B (y[1]) --1--> D (y[3])   (if y[1] & w=1)
// C (y[2]) --1--> D (y[3])   (if y[2] & w=1)
// E (y[4]) --1--> D (y[3])   (if y[4] & w=1)
// F (y[5]) --1--> D (y[3])   (if y[5] & w=1)

// So:
// Y3 = w & (y[1] | y[2] | y[4] | y[5])

assign Y1 = y[0] & (~w);
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule