module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // For clarity, assign named wires to input bits as per problem:
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // The Karnaugh map cells with output=1 correspond to the following input combinations:
    // Rows = x3 x4, Columns = x1 x2 (Gray code order: 00,01,11,10)
    // For each cell with 1, determine input bit pattern:

    // Cell (row=01, col=11): row=0x1 = x3=0, x4=1; col=11 Gray code corresponds to input bits (x1,x2) such that Gray(11) = binary input? The column Gray codes order is: 
    // Gray code: 00 (0), 01 (1), 11 (3), 10(2) - actually Gray to binary: 00->00, 01->01, 11->10, 10->11, so Gray "11" corresponds to binary "10" (x2=1,x1=0)
    // So col=11 Gray code corresponds to x2=1, x1=0
    // So inputs: x1=0, x2=1, x3=0, x4=1

    // Cell (row=11, col=00): x3=1,x4=1; col=00 Gray code → binary 00 → x2=0, x1=0
    // inputs: x1=0, x2=0, x3=1, x4=1

    // Cell (row=11, col=01): x3=1,x4=1; col=01 Gray code → binary 01 → x2=0, x1=1
    // inputs: x1=1, x2=0, x3=1, x4=1

    // Cell (row=10, col=00): x3=1,x4=0; col=00 Gray code → binary 00 → x2=0, x1=0
    // inputs: x1=0, x2=0, x3=1, x4=0

    // Cell (row=10, col=01): x3=1,x4=0; col=01 Gray code → binary 01 → x2=0, x1=1
    // inputs: x1=1, x2=0, x3=1, x4=0

    // Writing minterms as product terms (ANDs):

    wire m1 = (~x1) &  x2  & (~x3) &  x4;
    wire m2 = (~x1) & (~x2) &  x3  &  x4;
    wire m3 =  x1  & (~x2) &  x3  &  x4;
    wire m4 = (~x1) & (~x2) &  x3  & (~x4);
    wire m5 =  x1  & (~x2) &  x3  & (~x4);

    assign f = m1 | m2 | m3 | m4 | m5;

endmodule