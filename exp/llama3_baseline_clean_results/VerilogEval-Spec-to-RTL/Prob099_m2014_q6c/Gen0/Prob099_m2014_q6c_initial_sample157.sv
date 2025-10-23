module TopModule(
    input [5:0] y, 
    input w, 
    output Y1, 
    output Y3
);

// Next-state signal Y1 (y[0])
assign Y1 = (~w & y[0]) | (w & y[3]) | (~w & y[5]);

// Next-state signal Y3 (y[2])
assign Y3 = (~w & y[2]) | y[3] | (w & y[4]);

endmodule