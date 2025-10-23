module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Optimized direct next y[1] logic after minimizing the boolean expression
    // next_y1 = ( ~y2 & ~y1 & y0 ) | ( ~y2 & y1 & w ) | ( y2 & ~y1 & ( y0 | w ) )
    wire next_y1 = (~y2 & ~y1 & y0) | (~y2 & y1 & w) | (y2 & ~y1 & (y0 | w));

    assign Y1 = next_y1;

endmodule