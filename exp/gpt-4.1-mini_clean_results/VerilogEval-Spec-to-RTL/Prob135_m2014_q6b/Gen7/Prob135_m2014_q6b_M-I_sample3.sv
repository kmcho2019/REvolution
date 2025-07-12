module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire not_y2 = ~y[2];
    wire not_y1 = ~y[1];
    wire not_y0 = ~y[0];

    // mux_part = if y1=0 then y0 else (~y0 & w)
    wire mux_part = (not_y1 & y[0]) | (y[1] & not_y0 & w);

    // (y0 | w)
    wire y0_or_w = y[0] | w;

    // next_y1 = (~y2 & mux_part) | (y2 & ~y1 & y0_or_w)
    wire next_y1 = (not_y2 & mux_part) | (y[2] & not_y1 & y0_or_w);

    assign Y1 = y[1];

endmodule