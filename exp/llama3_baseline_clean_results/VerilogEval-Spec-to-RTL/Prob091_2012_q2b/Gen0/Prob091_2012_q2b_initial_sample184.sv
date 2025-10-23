module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is set when the current state is B or when transitioning to B from A (on w=1)
// Since F transitions to C on w=1, and C has y[2] set, we consider this in the logic
assign Y1 = (y[1] && !w) || (y[0] && w) || (y[5] && w);

// Y3 is set when the current state is D or when transitioning to D from B, C, E, or staying in D (on w=0)
assign Y3 = (y[3] && !w) || (y[1] && !w) || (y[2] && !w) || (y[4] && !w);

endmodule