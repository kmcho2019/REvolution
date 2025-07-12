module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode essential states (B, C, E, F) based on encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    wire B = (~y2) & (~y1) & y0;
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);
    wire F = y2 & (~y1) & y0;

    // Next state logic for y[1], derived from FSM transitions:
    wire next_y1 = B | (C & w) | (E & w) | F;

    assign Y1 = next_y1;

endmodule