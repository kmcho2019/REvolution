module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Combine B and F decoding: B=001, F=101 => (~y1) & y0
    wire BF = (~y1) & y0;

    // C and E decoding: C=010, E=100
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);

    // next_y1 = B | F | w & (C | E)
    wire next_y1 = BF | (w & (C | E));

    assign Y1 = next_y1;

endmodule