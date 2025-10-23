module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // Next state logic for y[1]
    wire next_y1 = 
        (~y2 & ~y1 & y0)         // B (001)
      | (~y2 & y1 & w)           // C (010) when w=1
      | (y2 & ~y1 & (w | y0));  // E (100) and F (101)

    // Output is current state's y[1]
    assign Y1 = y1;

endmodule