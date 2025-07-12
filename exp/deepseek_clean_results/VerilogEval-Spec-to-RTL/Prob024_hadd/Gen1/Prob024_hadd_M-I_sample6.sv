module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Using alternate operator syntax that might map to more efficient cells
    assign sum = a != b;  // Logical inequality is equivalent to XOR
    assign cout = a && b; // Logical AND (might use different cell than bitwise &)
endmodule