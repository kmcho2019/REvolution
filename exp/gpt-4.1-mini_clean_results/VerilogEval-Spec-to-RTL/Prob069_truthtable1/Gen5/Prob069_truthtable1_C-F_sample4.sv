module TopModule(
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Implement the minimal Boolean expression derived from the truth table:
    // f = (~x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);
endmodule