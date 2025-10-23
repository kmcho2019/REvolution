module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // Next state logic for y[1]
    // next_y1 = ( ~y2 & ~y1 & y0 ) | ( ~y2 & y1 & w ) | ( y2 & ~y1 & (w | y0) );
    wire next_y1 = 
        (~y2 & ~y1 & y0)           // From state B (001)
      | (~y2 & y1 & w)             // From states C (010) and E (100) when w=1
      | (y2 & ~y1 & (w | y0));    // From states F (101) and E (100)

    // Output is next state's y[1]
    assign Y1 = next_y1;

endmodule