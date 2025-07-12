module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    assign sum = a ^ b;    // Direct XOR for optimal sum calculation
    assign cout = a & b;   // Direct AND for optimal carry-out

endmodule