module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (~w & y[0]); // State A
assign Y3 = (w & (y[1] | y[2] | y[4] | y[5])) | (~w & y[2]);

endmodule