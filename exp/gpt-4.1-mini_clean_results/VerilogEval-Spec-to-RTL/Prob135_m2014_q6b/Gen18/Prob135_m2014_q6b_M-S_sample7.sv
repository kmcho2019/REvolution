module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    assign Y1 = y[1];

endmodule