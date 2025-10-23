module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on the correct transition from A to B
assign Y1 = (y[0] && w); // A(000001) transitions to B(000010) on w=1

// Assign Y3 based on transitions to D, simplified by factoring out !w
assign Y3 = !w && (y[1] || y[2] || y[4] || y[5]);

endmodule