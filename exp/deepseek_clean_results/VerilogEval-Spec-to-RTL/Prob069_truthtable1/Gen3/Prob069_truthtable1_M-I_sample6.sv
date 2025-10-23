module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as (x2 AND NOT x3) OR (x1 AND x3)
    assign f = (x2 & ~x3) | (x1 & x3);
endmodule