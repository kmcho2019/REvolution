module TopModule(
    input [3:0] x,
    output f
);
    assign f = x[2] | (x[1] & x[3]);
endmodule