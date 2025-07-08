module TopModule(
    input  [3:0] x,
    output      f
);

assign f = (x[3] & ~x[1]) | (x == 4'b0111);

endmodule