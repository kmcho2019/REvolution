module TopModule(
    input [3:0] x,
    output f
);

wire m1, m2, m3, m4, m5, m6;

// Generate minterms for x[2]x[3] = 00 and x[2]x[3] = 10
assign m1 = x[2] == 0 && x[3] == 0 && x[0] == 0 && x[1] == 0;
assign m2 = x[2] == 0 && x[3] == 0 && x[0] == 1 && x[1] == 0;
assign m3 = x[2] == 1 && x[3] == 0 && x[0] == 0 && x[1] == 0;
assign m4 = x[2] == 1 && x[3] == 0 && x[0] == 1 && x[1] == 0;
assign m5 = x[2] == 1 && x[3] == 0 && x[0] == 1 && x[1] == 1;
assign m6 = x[2] == 1 && x[3] == 1 && (x[0] == 0 && x[1] == 0 || x[0] == 0 && x[1] == 1 || x[0] == 1 && x[1] == 1);

assign f = (x[2] == 0 && x[3] == 0 && (m1 || m2)) ||
           (x[2] == 1 && x[3] == 0 && (m3 || m4 || m5)) ||
           (x[2] == 1 && x[3] == 1 && m6);

endmodule