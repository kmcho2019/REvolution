module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    wire not_y0 = ~y[0];
    wire not_y3 = ~y[3];
    wire not_w = ~w;

    assign Y1 = y[0] & w;  // Direct transition A->B when w=1
    assign Y3 = not_w & not_y0 & not_y3;  // Transitions to D from B/C/F when w=0

endmodule