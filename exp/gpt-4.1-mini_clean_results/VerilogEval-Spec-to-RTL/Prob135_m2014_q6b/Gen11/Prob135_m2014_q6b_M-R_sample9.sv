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

    // next_y1 logic directly as a combinational assign
    wire next_y1 = (B) | ((C | E) & w) | F;

    assign Y1 = next_y1;

endmodule