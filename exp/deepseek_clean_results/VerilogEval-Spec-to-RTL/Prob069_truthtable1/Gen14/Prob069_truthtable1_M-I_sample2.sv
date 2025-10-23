module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal mux implementation - cannot be improved further
    assign f = x3 ? x1 : x2;
endmodule