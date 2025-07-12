module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

wire group0, group1;

assign group0 = y[1] | y[2];  // B or C
assign group1 = y[4] | y[5];  // E or F

assign Y1 = y[0] & w;               // from A to B on w=1
assign Y3 = (~w) & (group0 | group1); // from B,C,E,F to D on w=0

endmodule