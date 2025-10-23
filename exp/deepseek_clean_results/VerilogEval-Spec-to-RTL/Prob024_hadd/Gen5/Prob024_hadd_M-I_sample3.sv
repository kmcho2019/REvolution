module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Optimal implementation - cannot be improved at RTL level
    assign sum = a ^ b;
    assign cout = a & b;

endmodule