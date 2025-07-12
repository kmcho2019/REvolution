module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Direct implementation based on the truth table conditions
assign f = (x2 & ~x3) | (x1 & x3);

// Alternatively, considering the conditions under which f is 1, 
// we could express it as follows, though this does not necessarily offer PPA improvements:
// assign f = (~x3 & x2) | (x3 & x1);

// Another potential implementation using NAND and NOR gates:
// assign f = ~(~(x2 & ~x3) & ~(x1 & x3));

endmodule