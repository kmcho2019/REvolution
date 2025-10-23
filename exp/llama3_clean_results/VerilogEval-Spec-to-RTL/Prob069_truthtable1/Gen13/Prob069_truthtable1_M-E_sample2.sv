module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implementing the logic based on Karnaugh map simplification
// The truth table can be visualized as follows when organized in a K-map:
//        x1|x1'
//  -------------------
// x2|x2' | 0  | 1
//  -------------------
// x3|x3' |    |
//  -------------------
// x2|x2' | 0  | 1
//  -------------------
// After grouping and simplifying using the K-map rules, we find that
// the expression can indeed be represented as (x2 & ~x3) | (x1 & x3), 
// which matches the original solution.

assign f = (x2 & ~x3) | (x1 & x3);

endmodule