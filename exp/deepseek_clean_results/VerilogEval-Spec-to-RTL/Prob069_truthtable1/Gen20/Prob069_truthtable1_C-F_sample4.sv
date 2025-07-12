module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implements truth table using x3 as mux select:
    // When x3=0, output is x2
    // When x3=1, output is x1
    assign f = x3 ? x1 : x2;
endmodule