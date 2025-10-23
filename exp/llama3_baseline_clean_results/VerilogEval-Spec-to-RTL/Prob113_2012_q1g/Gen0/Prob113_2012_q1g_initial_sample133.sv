module TopModule(
    input [3:0] x,
    output f
);

assign f = (x == 4'b0000) || (x == 4'b0010) || (x == 4'b1010) || 
           (x[3:2] == 2'b11 && x[1:0] != 2'b11);

endmodule