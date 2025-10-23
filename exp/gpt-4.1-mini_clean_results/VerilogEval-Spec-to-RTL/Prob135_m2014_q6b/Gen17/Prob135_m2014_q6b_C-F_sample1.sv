module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Name individual bits for clarity
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // next state logic for y[1]
    wire next_y1 = (y0 & ~y1) | (~y0 & w & (y1 | y2));

    assign Y1 = next_y1;

endmodule