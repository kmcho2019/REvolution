module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// one-hot encoded states
wire A = y[0];
wire B = y[1];
wire C = y[2];
wire D = y[3];
wire E = y[4];
wire F = y[5];

// next-state signals
assign Y2 = (~w & B) | (~w & F) | (w & C) | (w & E); // y[1] for state B
assign Y4 = (~w & C) | (w & B) | (~w & E) | (w & E); // y[3] for state D

assign Y1 = A;
assign Y3 = D;

endmodule