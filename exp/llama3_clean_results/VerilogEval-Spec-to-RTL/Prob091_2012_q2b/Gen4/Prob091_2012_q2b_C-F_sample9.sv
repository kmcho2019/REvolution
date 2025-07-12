module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 based on the transition from A to B
// A (000001) transitions to B (000010) on w=1
assign Y1 = w & y[0];

// Assign Y3 based on transitions to D
// B (000010), C (000100), E (010000), and F (100000) transition to D (001000) on w=0
assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule