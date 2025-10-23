module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // States encoded as:
    // A = 000, B = 001, C = 010, D = 011, E = 100, F = 101

    // B = ~y2 & ~y1 & y0
    // C = ~y2 & y1 & ~y0
    // E = y2 & ~y1 & ~y0
    // F = y2 & ~y1 & y0

    wire B = ~y2 & ~y1 & y0;
    wire C = ~y2 & y1 & ~y0;
    wire E = y2 & ~y1 & ~y0;
    wire F = y2 & ~y1 & y0;

    // next_y1 = B | F | (w & (C | E));
    // Output Y1 = y[1]
    assign Y1 = B | F | (w & (C | E));

endmodule