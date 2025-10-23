module TopModule(
    input [3:0] x,  // x[3:4] are MSBs, x[1:2] are LSBs
    output f
);
    assign f = x[3] | (x[1] & ~x[2] & ~x[4]);
endmodule