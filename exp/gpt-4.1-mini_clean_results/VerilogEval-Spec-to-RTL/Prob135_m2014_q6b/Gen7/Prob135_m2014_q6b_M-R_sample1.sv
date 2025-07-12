module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Extract bits for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Direct next y[1] logic from state codes and transitions:
    // next_y1 = (B) + (C & w) + (E & w) + F
    // B = 001 => ~y2 & ~y1 & y0
    // C = 010 => ~y2 & y1 & ~y0
    // E = 100 => y2 & ~y1 & ~y0
    // F = 101 => y2 & ~y1 & y0

    assign Y1 = (~y2 & ~y1 & y0)          // B
              | (~y2 & y1 & ~y0 & w)    // C & w
              | (y2 & ~y1 & ~y0 & w)    // E & w
              | (y2 & ~y1 & y0);        // F

endmodule