module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode state bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for y[1] derived from FSM transitions:
    // Y1 = (~y1 & y0) | (w & (y1 | y2) & ~y0)
    assign Y1 = (~y1 & y0) | (w & (y1 | y2) & ~y0);

endmodule