module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on the state transitions
assign Y1 = (y[0] &&!w); // A(000001) can transition to B(000010) on w=0

// Assign Y3 based on the state transitions
assign Y3 = (y[1] &&!w) || (y[2] &&!w) || (y[4] &&!w) || (y[5] &&!w) || (y[3] &&!w);

endmodule