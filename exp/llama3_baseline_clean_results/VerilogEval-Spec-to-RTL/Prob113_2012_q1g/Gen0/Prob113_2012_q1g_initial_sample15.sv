module TopModule (
    input  [3:0] x,
    output       f
);

assign f = (x == 4'b0000) | (x == 4'b1000) | (x == 4'b0011) | 
           (x == 4'b1011) | (x == 4'b1111) | (x == 4'b1010);

endmodule