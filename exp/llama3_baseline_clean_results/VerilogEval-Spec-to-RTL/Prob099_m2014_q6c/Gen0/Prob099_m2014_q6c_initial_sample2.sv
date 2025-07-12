module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = (~w & y[0]) | (~w & y[5]); // Next state is B
assign Y3 = (w & y[1]) | (w & y[2]) | (w & y[4]) | (w & y[3]); // Next state is D

endmodule