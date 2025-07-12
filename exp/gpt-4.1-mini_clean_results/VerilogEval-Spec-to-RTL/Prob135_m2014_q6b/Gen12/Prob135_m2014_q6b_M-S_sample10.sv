module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Output y[1] directly as per the problem statement
    assign Y1 = y[1];

endmodule