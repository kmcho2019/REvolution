module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // A→B transition when w=1
    
    // Equivalent to: transitions to D from B(w=0), C(w=0), or F(w=0)
    assign Y3 = (y[1] | y[2] | y[5]) & ~w;

endmodule