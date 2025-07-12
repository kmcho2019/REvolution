module TopModule(
    input  wire [2:0] y,  // Current state bits: y2 y1 y0
    input  wire       w,  // Input controlling transitions
    output wire       Y1  // Next-state bit y[1]
);

    // Decode state bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for y[1] using a mux on y0:
    // When y0=0: Y1 = w & (y1 | y2)
    // When y0=1: Y1 = ~y1
    assign Y1 = y0 ? (~y1) : (w & (y1 | y2));

endmodule