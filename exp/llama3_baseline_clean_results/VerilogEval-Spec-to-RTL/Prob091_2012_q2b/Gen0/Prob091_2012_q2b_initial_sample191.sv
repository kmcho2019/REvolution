module TopModule(
    input [5:0] y,  // current state
    input w,        // input
    output Y1,      // input of state flip-flop y[1]
    output Y3       // input of state flip-flop y[3]
);

// Logic for Y1
assign Y1 = (y[0] &&!w) || (y[1] &&!w) || (y[2] && w) || (y[4] && w) || (y[4] &&!w);

// Logic for Y3
assign Y3 = (y[0] && w) || (y[1] &&!w) || (y[2] &&!w) || (y[3] && w) || (y[3] &&!w) || (y[4] &&!w) || (y[5] &&!w);

endmodule