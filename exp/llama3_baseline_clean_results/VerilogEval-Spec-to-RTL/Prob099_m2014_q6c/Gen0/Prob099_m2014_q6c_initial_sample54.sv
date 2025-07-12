module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A to F
wire A = y[0];
wire B = y[1];
wire C = y[2];
wire D = y[3];
wire E = y[4];
wire F = y[5];

// Next-state signals Y2 and Y4
assign Y2 = (~w & (A | F));  // next state is B
assign Y4 = (w & (B | C | E | D));  // next state is D

// Output signals
assign Y1 = y[0];  // current state A
assign Y3 = y[3];  // current state D

endmodule