module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decompose y for readability
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Implement next y[1] logic by fusing the two approaches:
    // next_y1 = 1 for states B(001) and F(101) regardless of w,
    // and equals w for states C(010) and E(100),
    // otherwise 0.

    // Conditions for next_y1 = 1 regardless of w:
    wire is_B = (~y2 & ~y1 & y0); // 001
    wire is_F = (y2 & ~y1 & y0);  // 101

    // Conditions for next_y1 = w:
    wire is_C = (~y2 & y1 & ~y0); // 010
    wire is_E = (y2 & ~y1 & ~y0); // 100

    assign Y1 = is_B | is_F | ((is_C | is_E) & w);

endmodule