module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Output Y1 is simply the current state's middle bit y[1].
    assign Y1 = y[1];

endmodule