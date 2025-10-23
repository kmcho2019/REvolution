module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Optimal fused implementation: clear, efficient, and maintainable
    assign sum = a ^ b;
    assign cout = a & b;

endmodule