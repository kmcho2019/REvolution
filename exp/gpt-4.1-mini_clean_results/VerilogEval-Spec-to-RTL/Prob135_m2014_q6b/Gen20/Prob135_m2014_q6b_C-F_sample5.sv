module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire y1_or_y2 = y1 | y2;
    wire not_y0 = ~y0;
    wire not_y1 = ~y1;

    wire next_y1 = (y0 & not_y1) | (not_y0 & w & y1_or_y2);

    assign Y1 = next_y1;

endmodule