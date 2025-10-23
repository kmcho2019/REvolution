module TopModule(
    input [3:0] x,
    output f
);
    // Index: {x[3], x[2], x[1], x[0]} as bits 3..0
    // Karnaugh map given with rows = x[3]x[4], columns = x[1]x[2]
    // Since x[4] doesn't exist, assume input order is x[3:0] = {x3,x2,x1,x0}
    // We'll map inputs as x[3]x[2]x[1]x[0] indexing truth table 0 to 15.

    // Map the Karnaugh values to the 16 possible inputs:
    // Using the table (row bits = x[3]x[0], col bits = x[1]x[2]):
    // For each x = {x[3], x[2], x[1], x[0]}
    // row = {x[3], x[0]}, col = {x[1], x[2]}
    // So address in K-map = row *4 + col

    // Build truth table with 'f' values (d=0 for simplicity):
    // row\col  00   01   11   10
    // 00       d    0    d    d
    // 01       0    d    1    0
    // 11       1    1    d    d
    // 10       1    1    0    d

    // We compute f for each x = {x3 x2 x1 x0}
    // Let's create a 16-bit constant with f values in order 0 to 15:

    // For x in decimal (x3 x2 x1 x0):
    //  0 (0000): row=00 col=00 -> d=0
    //  1 (0001): row=01 col=00 -> 0
    //  2 (0010): row=00 col=10 -> d=0
    //  3 (0011): row=01 col=10 -> 0
    //  4 (0100): row=00 col=01 -> 0
    //  5 (0101): row=01 col=01 -> d=0
    //  6 (0110): row=00 col=11 -> d=0
    //  7 (0111): row=01 col=11 -> 1
    //  8 (1000): row=10 col=00 -> 1
    //  9 (1001): row=11 col=00 -> 1
    // 10 (1010): row=10 col=10 -> 0
    // 11 (1011): row=11 col=10 -> d=0
    // 12 (1100): row=10 col=01 -> 1
    // 13 (1101): row=11 col=01 -> 1
    // 14 (1110): row=10 col=11 -> d=0
    // 15 (1111): row=11 col=11 -> d=0

    // Values per index: 
    // [0]=0, [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=1,
    // [8]=1, [9]=1, [10]=0, [11]=0, [12]=1, [13]=1, [14]=0, [15]=0

    wire [15:0] lut = 16'b0000110011000000;
    assign f = lut[x];
endmodule