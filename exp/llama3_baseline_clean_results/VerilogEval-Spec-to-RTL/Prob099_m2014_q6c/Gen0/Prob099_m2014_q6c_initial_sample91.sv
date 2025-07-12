module TopModule(y, w, Y1, Y3);
    input [5:0] y;  // One-hot encoded state
    input w;
    output Y1;  // Next-state signal corresponding to y[1]
    output Y3;  // Next-state signal corresponding to y[3]

    // Logic equations for next-state signals
    assign Y1 = (y[0] && !w);  // State B can be reached from A when w = 0
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);  // State D can be reached from B, C, E, F when w = 1
endmodule