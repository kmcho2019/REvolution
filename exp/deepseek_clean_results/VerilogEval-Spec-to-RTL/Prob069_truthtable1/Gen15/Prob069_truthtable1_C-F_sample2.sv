module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal fused solution: mux implementation
    // When x3=0: f = x2 (covers first 4 rows)
    // When x3=1: f = x1 (covers last 4 rows)
    assign f = x3 ? x1 : x2;
endmodule