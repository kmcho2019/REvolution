module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // B = 001: ~y2 & ~y1 & y0
    // C = 010: ~y2 & y1 & ~y0
    // E = 100: y2 & ~y1 & ~y0
    // F = 101: y2 & ~y1 & y0

    assign Y1 = 
        ((~y2) & (~y1) & y0)                 // B
      | (y2 & (~y1) & y0)                   // F
      | (w & (
           ((~y2) & y1 & (~y0))             // C
         | (y2 & (~y1) & (~y0))             // E
        ));

endmodule