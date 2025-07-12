module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Decode states from y
    wire B = (~y[2] & ~y[1] &  y[0]);
    wire C = (~y[2] &  y[1] & ~y[0]);
    wire E = ( y[2] & ~y[1] & ~y[0]);
    wire F = ( y[2] & ~y[1] &  y[0]);

    // Next state logic for y[1]
    assign Y1 = B | F | (w & (C | E));

endmodule