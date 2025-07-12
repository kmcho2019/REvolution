module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal implementation - same as original
    assign f = x3 ? x1 : x2;
endmodule