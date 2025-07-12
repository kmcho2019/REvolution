module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal fused implementation:
    // - Uses mux structure for hardware efficiency
    // - Directly implements the minimal Boolean expression
    // - Combines best aspects of both solutions
    assign f = x3 ? x1 : x2;
endmodule