module TopModule(
    input [3:0] x,
    output f
);
    // Input bits:
    // Rows are x[3] (MSB), x[0] (LSB)  => row = {x[3], x[0]}
    // Columns are x[1] (MSB), x[2] (LSB) => col = {x[1], x[2]}
    // We will decode the Karnaugh map cells where f=1:

    // Karnaugh map cells with f=1:
    // Rows (x[3] x[0]) 00 01 11 10
    // Cols (x[1] x[2]) 00 01 11 10
    // ---------------------------------
    // (11,00): 1  -> x[3]=1,x[0]=1,x[1]=0,x[2]=0  -> x=1 0 0 1 = 4'b1001
    // (11,01): 1  -> x[3]=1,x[0]=1,x[1]=0,x[2]=1  -> x=1 0 1 1 = 4'b1011
    // (10,00): 1  -> x[3]=1,x[0]=0,x[1]=0,x[2]=0  -> x=1 0 0 0 = 4'b1000
    // (10,01): 1  -> x[3]=1,x[0]=0,x[1]=0,x[2]=1  -> x=1 0 1 0 = 4'b1010
    // (01,11): 1  -> x[3]=0,x[0]=1,x[1]=1,x[2]=1  -> x=0 1 1 1 = 4'b0111

    // f = 1 when x is one of above 5 minterms

    assign f = (x == 4'b1001) ||
               (x == 4'b1011) ||
               (x == 4'b1000) ||
               (x == 4'b1010) ||
               (x == 4'b0111);

endmodule