module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // From the truth table:
    // f=1 for inputs: 010, 011, 101, 111
    // Let's write minterms:
    // (x3=0,x2=1,x1=0) => !x3 & x2 & !x1
    // (x3=0,x2=1,x1=1) => !x3 & x2 & x1
    // (x3=1,x2=0,x1=1) => x3 & !x2 & x1
    // (x3=1,x2=1,x1=1) => x3 & x2 & x1
    // Combine terms:
    // f = (!x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);
endmodule