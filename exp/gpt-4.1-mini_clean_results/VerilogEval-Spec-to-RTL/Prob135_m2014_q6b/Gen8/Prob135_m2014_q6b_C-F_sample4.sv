module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // State bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode essential states:
    // A=000, B=001, C=010, D=011, E=100, F=101
    wire B = (~y2) & (~y1) &  y0;  // 001
    wire C = (~y2) &  y1  & (~y0); // 010
    wire E =  y2  & (~y1) & (~y0); // 100
    wire F =  y2  & (~y1) &  y0;   // 101

    // Factor input w for states C and E
    wire CE_w = w & (C | E);

    // Next-state logic for y[1]
    wire next_y1 = B | F | CE_w;

    // Output assignment
    assign Y1 = next_y1;

endmodule