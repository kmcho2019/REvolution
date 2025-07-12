module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

assign Y1 = (~w) & (y[0] | y[1]);
assign Y3 = (~w) & (y[3] | y[4]);

endmodule