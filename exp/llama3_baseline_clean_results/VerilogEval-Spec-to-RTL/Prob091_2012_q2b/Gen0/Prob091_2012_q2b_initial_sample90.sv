module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is high when the next state is B
assign Y1 = (~w & y[0]);  // A -> B, w = 0

// Y3 is high when the next state is D
assign Y3 = (~w & (y[1] | y[2] | y[4]));  // B, C, E -> D, w = 0 or D -> D, w = 0

endmodule