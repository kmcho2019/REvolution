module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states B, C, E, F from current state y
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire B = (~y2) & (~y1) & y0;
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);
    wire F = y2 & (~y1) & y0;

    // next y[1] logic optimized by factoring
    wire CE_or = C | E;
    wire next_y1 = (B | F) | (CE_or & w);

    // Output Y1 = next y[1]
    assign Y1 = next_y1;

endmodule