module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Extract state bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // next_y1 = 1 for states B(001) or F(101) regardless of w,
    // or for states C(010) or E(100) only when w=1.
    wire next_y1 = (y0 & ~y1) | (w & ((y1 | y2) & ~y0));

    // Output Y1 is next state logic for y[1]
    assign Y1 = next_y1;

endmodule