module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states
    wire B = ~y[2] & ~y[1] & y[0];
    wire C = ~y[2] & y[1] & ~y[0];
    wire E = y[2] & ~y[1] & ~y[0];
    wire F = y[2] & ~y[1] & y[0];

    // Factor w and common bits: Y1 = B | F | (w & ~y[1] & (C | E))
    assign Y1 = B | F | (w & ~y[1] & (C | E));

endmodule