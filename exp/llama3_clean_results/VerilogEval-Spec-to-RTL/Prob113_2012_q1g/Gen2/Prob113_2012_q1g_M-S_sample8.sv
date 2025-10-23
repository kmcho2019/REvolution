module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[2] == 0 && x[3] == 0 && (x[0] == x[1])) ||
           (x[2] == 1 && x[3] == 1) ||
           (x[2] == 1 && x[3] == 0 && x[1] == 0);

endmodule