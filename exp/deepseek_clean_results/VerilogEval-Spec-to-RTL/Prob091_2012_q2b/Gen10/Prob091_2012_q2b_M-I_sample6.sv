module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = y[0] & w;  // A→B transition when w=1
    assign Y3 = ~(w | y[0] | y[3]);  // Transitions to D from B/C/F when w=0

endmodule