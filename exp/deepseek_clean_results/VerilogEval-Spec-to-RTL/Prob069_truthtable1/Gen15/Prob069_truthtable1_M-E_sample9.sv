module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Hierarchical decoder implementation
    assign f = x3 ? x1 : x2;
endmodule