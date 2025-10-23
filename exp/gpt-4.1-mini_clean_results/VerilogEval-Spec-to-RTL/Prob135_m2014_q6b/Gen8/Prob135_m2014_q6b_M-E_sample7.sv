module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // State encodings: A=000, B=001, C=010, D=011, E=100, F=101
    // next_y1 is 1 for states B, C (when w=1), E (when w=1), and F unconditionally
    // Using direct Boolean expression derived from these conditions:

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // next_y1 = (state == B) + ((state == C) & w) + ((state == E) & w) + (state == F)

    wire is_B = (~y2) & (~y1) & y0;    // 001
    wire is_C = (~y2) & y1 & (~y0);    // 010
    wire is_E = y2 & (~y1) & (~y0);    // 100
    wire is_F = y2 & (~y1) & y0;       // 101

    wire next_y1 = is_B | (is_C & w) | (is_E & w) | is_F;

    assign Y1 = next_y1;

endmodule