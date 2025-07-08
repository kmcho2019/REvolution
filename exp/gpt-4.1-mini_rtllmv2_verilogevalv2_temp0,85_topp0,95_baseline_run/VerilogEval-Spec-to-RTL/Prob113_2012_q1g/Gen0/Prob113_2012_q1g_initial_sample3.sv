module TopModule (
    input  [3:0] x,
    output      f
);
    // Assign inputs to variables for clarity:
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Output f is 1 for the following minterms (row col):
    // (00,00) => x3=0,x2=0,x1=0,x0=0
    // (00,10) => x3=0,x2=0,x1=1,x0=0
    // (11,00) => x3=1,x2=1,x1=0,x0=0
    // (11,01) => x3=1,x2=1,x1=0,x0=1
    // (11,11) => x3=1,x2=1,x1=1,x0=1
    // (10,00) => x3=1,x2=0,x1=0,x0=0
    // (10,01) => x3=1,x2=0,x1=0,x0=1
    // (10,10) => x3=1,x2=0,x1=1,x0=0
    // (00,00) and (10,11) also 1

    // Let's write down all minterms explicitly:
    assign f = 
        (~x3 & ~x2 & ~x1 & ~x0) | // (00,00)
        (~x3 & ~x2 &  x1 & ~x0) | // (00,10)
        ( x3 &  x2 & ~x1 & ~x0) | // (11,00)
        ( x3 &  x2 & ~x1 &  x0) | // (11,01)
        ( x3 &  x2 &  x1 &  x0) | // (11,11)
        ( x3 & ~x2 & ~x1 & ~x0) | // (10,00)
        ( x3 & ~x2 & ~x1 &  x0) | // (10,01)
        ( x3 & ~x2 &  x1 & ~x0) | // (10,10)
        (~x3 &  x2 & ~x1 &  x0) | // (01,01) is zero, skip
        ( x3 & ~x2 &  x1 &  x0) | // (10,11) check map: at (10,11) = 1
        ( x3 &  x2 &  x1 & ~x0);  // (11,10) is zero in map, skip

    // Correct terms:
    // From map, (10,11) = (x3=1,x2=0,x1=1,x0=1) => 1
    // Add that term:
    // Also verify (11,10) is 0 => exclude

endmodule