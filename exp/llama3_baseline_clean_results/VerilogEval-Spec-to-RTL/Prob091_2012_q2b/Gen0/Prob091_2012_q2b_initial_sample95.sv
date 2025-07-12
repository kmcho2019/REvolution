module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be high when the state machine is in state B (000010) or D (001000)
assign Y1 = (y[1] && !w) || (y[0] && w) || (y[5] && !w) || (y[4] && w) || (y[3] && !w);

// Y3 should be high when the state machine is in state D (001000)
assign Y3 = (y[2] && !w) || (y[3] && !w) || (y[4] && !w) || (y[5] && !w);

endmodule