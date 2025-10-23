module TopModule (
    input  [5:0] y,  // current state
    input        w,  // input signal
    output       Y1, // next state y[0]
    output       Y3  // next state y[2]
);

    // Deriving the logic equations for Y2 and Y4
    assign Y2 = (y[0] & w) | (y[2] & ~w);  // next state y[1]
    assign Y4 = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[3] & w);  // next state y[3]

    // For this problem we dont use Y1 and Y3 so we leave them unconnected.
    // However in real scenario you should use them or assign a default value to them.
    assign Y1 = 1'b0;
    assign Y3 = 1'b0;

endmodule