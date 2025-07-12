module TopModule (
    input  [5:0] y,    // current state one-hot: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,   // next-state bit corresponding to y[1] (B)
    output       Y4    // next-state bit corresponding to y[3] (D)
);

// Derive Y2 (next B) from transitions:
// A(0) --0--> B
// Thus, Y2 = y[0] & ~w

assign Y2 = y[0] & ~w;

// Derive Y4 (next D) from transitions:
// B(0) --1--> D
// C(0) --1--> D
// D(0) --1--> A (not D)
// E(1) --1--> D
// F(1) --1--> D
// Therefore, all states except A on w=1 lead to D except D itself does not go to D on 1
// More precisely:
// From B,C,E,F on w=1, go to D
// Also from D on w=0 to F, not to D
// So Y4 = w & (y[1] | y[2] | y[4] | y[5])

assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule