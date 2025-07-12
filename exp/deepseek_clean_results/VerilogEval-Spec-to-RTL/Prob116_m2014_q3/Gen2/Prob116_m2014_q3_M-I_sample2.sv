module TopModule(
    input [3:0] x,  // x[3] = row MSB, x[0] = row LSB; x[2:1] = columns
    output f
);
    assign f = (x[3] & ~x[2]) | 
               (~x[3] & x[0] & x[2] & x[1]);
endmodule