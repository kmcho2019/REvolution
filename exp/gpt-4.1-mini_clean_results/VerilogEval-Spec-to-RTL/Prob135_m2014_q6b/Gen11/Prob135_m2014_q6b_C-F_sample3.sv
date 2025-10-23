module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decompose inputs for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Optimized next_y1 logic derived from FSM transitions with minimal terms:
    // next_y1 = (~y2 & ~y1 & y0)               // state B
    //         | (~y2 & y1 & ~y0 & w)            // state C and input w
    //         | (y2 & ~y1 & (y0 | w));          // states E or F with w or y0

    assign Y1 = (~y2 & ~y1 & y0)
              | (~y2 & y1 & ~y0 & w)
              | (y2 & ~y1 & (y0 | w));

endmodule