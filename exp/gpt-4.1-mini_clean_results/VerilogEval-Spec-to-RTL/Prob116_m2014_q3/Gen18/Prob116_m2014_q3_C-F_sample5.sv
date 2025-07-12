module TopModule (
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Extract inputs for clarity
    wire x1 = x[0]; // column Gray bit 1
    wire x2 = x[1]; // column Gray bit 0
    wire x3 = x[2]; // row Gray bit 1
    wire x4 = x[3]; // row Gray bit 0

    // Gray to binary conversion for row (x3,x4)
    wire r1 = x3;
    wire r0 = x3 ^ x4;

    // Gray to binary conversion for column (x1,x2)
    wire c1 = x1;
    wire c0 = x1 ^ x2;

    // Derived minimal logic from Karnaugh map '1's and factoring:
    // Ones are at binary addresses (row, column):
    // (11,00), (11,01), (10,00), (10,01), (01,11)
    //
    // From example 1 minterms:
    // (r1=1,r0=1,c1=0,c0=0)
    // (r1=1,r0=1,c1=0,c0=1)
    // (r1=1,r0=0,c1=0,c0=0)
    // (r1=1,r0=0,c1=0,c0=1)
    // (r1=0,r0=1,c1=1,c0=1)
    //
    // Factor:
    // f = r1 & ~c1 & ~c0        (covers (11,00),(10,00))
    //   | r1 & ~c1 & c0         (covers (11,01),(10,01))
    //   | ~r1 & r0 & c1 & c0    (covers (01,11))

    assign f = (r1 & ~c1 & ~c0)
             | (r1 & ~c1 &  c0)
             | (~r1 & r0 & c1 & c0);

endmodule