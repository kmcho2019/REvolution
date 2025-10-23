module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    wire y1_xor_y0 = y1 ^ y0;

    wire term1 = (~y2) & y1_xor_y0;
    wire term2 = w & y2 & (~y1);
    wire term3 = (~w) & y2 & (~y1) & y0;

    wire next_y1 = term1 | term2 | term3;

    assign Y1 = next_y1;

endmodule