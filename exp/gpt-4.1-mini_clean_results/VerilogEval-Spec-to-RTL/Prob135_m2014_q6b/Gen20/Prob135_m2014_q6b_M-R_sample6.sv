module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire term1, term2, term3;
    wire next_y1;

    assign term1 = y[0] & ~y[1];
    assign term2 = ~y[0];
    assign term3 = w & (y[1] | y[2]);

    assign next_y1 = term1 | (term2 & term3);

    assign Y1 = next_y1;

endmodule