module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // f = (NOT x3 AND x2) OR (x3 AND x1)
    // When x3=0: f = x2
    // When x3=1: f = x1
    assign f = (~x3 & x2) | (x3 & x1);
endmodule