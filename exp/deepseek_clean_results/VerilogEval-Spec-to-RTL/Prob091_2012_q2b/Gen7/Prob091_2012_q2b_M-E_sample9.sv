module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is simply transition from A when w=1
    assign Y1 = y[0] & w;

    // Y3 implementation using priority concept
    wire transition_to_D;
    assign transition_to_D = (~w & (y[1] | y[2] | y[5])) | (w & y[4]);
    assign Y3 = transition_to_D;

endmodule