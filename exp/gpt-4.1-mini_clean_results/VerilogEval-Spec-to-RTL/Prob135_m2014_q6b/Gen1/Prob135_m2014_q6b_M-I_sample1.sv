module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    // Current state bits
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // next_y1 logic from the state transitions
    // States: A=000, B=001, C=010, D=011, E=100, F=101

    wire next_y1 = 
        (~y2 & ~y1 & y0)             // State B (001)
      | (~y2 & y1 & w)              // States C(010) and E(100) when w=1
      | (y2 & ~y1 & (w | y0));     // States F(101) and E(100)

    // Output the next state's y[1]
    assign Y1 = next_y1;

endmodule