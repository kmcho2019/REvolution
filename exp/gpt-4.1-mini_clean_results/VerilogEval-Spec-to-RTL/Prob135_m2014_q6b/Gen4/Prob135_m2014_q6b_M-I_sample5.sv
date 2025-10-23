module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states
    wire B = (~y2) & (~y1) & y0;
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);
    wire F = y2 & (~y1) & y0;

    // Factor common terms to optimize next y[1] logic
    wire CE = C | E;
    wire next_y1 = B | (w & CE) | F;

    assign Y1 = next_y1;

endmodule