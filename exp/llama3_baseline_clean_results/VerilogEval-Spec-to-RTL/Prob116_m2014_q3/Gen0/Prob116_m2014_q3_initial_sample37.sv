module TopModule(
    input [3:0] x, // input x is 4 bits, but since the index starts from 3 and goes down to 0, we represent x as x[3]x[2]x[1]x[0]
    output f
);

    assign f = (x[3] & ~x[0] & (x[1] | x[2])) | // x[3]x[0] = 10 and (x[1] or x[2] is high)
               (~x[3] & x[0] & (x[1] | x[2])) | // x[3]x[0] = 01 and (x[1] or x[2] is high)
               (x[3] & x[0] & (x[1] | x[2]));   // x[3]x[0] = 11 and (x[1] or x[2] is high)

endmodule