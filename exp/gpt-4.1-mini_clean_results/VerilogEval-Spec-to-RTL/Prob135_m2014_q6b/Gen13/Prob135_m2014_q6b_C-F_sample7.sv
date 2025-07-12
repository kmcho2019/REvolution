module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states needed for next y1 logic:
    wire is_B = ~y2 & ~y1 &  y0;  // 001
    wire is_C = ~y2 &  y1 & ~y0;  // 010
    wire is_E =  y2 & ~y1 & ~y0;  // 100
    wire is_F =  y2 & ~y1 &  y0;  // 101

    // next y1 bit logic based on FSM transitions:
    // next_y1 = is_B | (is_C & w) | (is_E & w) | is_F
    assign Y1 = is_B | (is_C & w) | (is_E & w) | is_F;

endmodule