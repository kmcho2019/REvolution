module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // next-state logic for y[1], implemented as combinational logic
    wire next_y1 = (y0 & ~y1) | (w & ((y1 | y2) & ~y0));

    // Output Y1 is the next state bit y[1]
    assign Y1 = next_y1;

endmodule