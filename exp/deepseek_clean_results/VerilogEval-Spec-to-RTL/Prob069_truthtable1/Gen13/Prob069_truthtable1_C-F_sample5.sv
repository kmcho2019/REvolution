module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // f = x2 when x3=0, x1 when x3=1 (from truth table)
    assign f = x3 ? x1 : x2;
endmodule