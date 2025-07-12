module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Default outputs
    Y1 = 1'b0;
    Y3 = 1'b0;

    // Compute Y1: next state input for y[1] (B)
    // Transition: A (y[0]) & w==1 --> B
    if (y[0] && w)
        Y1 = 1'b1;
    else
        Y1 = 1'b0;

    // Compute Y3: next state input for y[3] (D)
    // Transitions to D occur from B, C, E, F on w == 0
    if ((y[1] || y[2] || y[4] || y[5]) && !w)
        Y3 = 1'b1;
    else
        Y3 = 1'b0;
end

endmodule