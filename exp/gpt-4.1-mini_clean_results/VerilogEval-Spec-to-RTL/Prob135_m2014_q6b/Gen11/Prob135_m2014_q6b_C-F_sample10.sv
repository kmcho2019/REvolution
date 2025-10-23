module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decompose state bits for clarity and reuse
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire not_y2 = ~y2;
    wire not_y1 = ~y1;
    wire not_y0 = ~y0;

    // Decode states B, C, E, F
    wire B = not_y2 & not_y1 &  y0;  // 001
    wire C = not_y2 &  y1  & not_y0; // 010
    wire E =  y2  & not_y1 & not_y0; // 100
    wire F =  y2  & not_y1 &  y0;   // 101

    // Factor common term for (C | E) & w = ((~y2 & y1 & ~y0) | (y2 & ~y1 & ~y0)) & w
    // common ~y0 & w factor inside (C | E)
    wire CE_and_w = w & not_y0 & ( (not_y2 & y1) | (y2 & not_y1) );

    // next_y1 = B | F | ((C | E) & w)
    wire next_y1 = B | F | CE_and_w;

    assign Y1 = next_y1;

endmodule