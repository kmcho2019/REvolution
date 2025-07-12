module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Decoder outputs
    wire d0 = ~x3 & ~x2 & ~x1;
    wire d1 = ~x3 & ~x2 &  x1;
    wire d2 = ~x3 &  x2 & ~x1;
    wire d3 = ~x3 &  x2 &  x1;
    wire d4 =  x3 & ~x2 & ~x1;
    wire d5 =  x3 & ~x2 &  x1;
    wire d6 =  x3 &  x2 & ~x1;
    wire d7 =  x3 &  x2 &  x1;

    // OR together the active minterms
    assign f = d2 | d3 | d5 | d7;
endmodule