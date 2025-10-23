module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Decode states B, C, E, F with minimal inversions by rearranging logic:
    // B = 001 => ~y2 & ~y1 & y0
    // C = 010 => ~y2 & y1 & ~y0
    // E = 100 => y2 & ~y1 & ~y0
    // F = 101 => y2 & ~y1 & y0

    wire B = (~y2) & (~y1) & y0;
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);
    wire F = y2 & (~y1) & y0;

    // Factor the next y[1] logic to reduce gates: B | F | w & (C | E)
    wire CE = C | E;
    wire next_y1 = B | F | (w & CE);

    assign Y1 = next_y1;

endmodule