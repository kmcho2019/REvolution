module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Sum is XOR of inputs (1 when inputs differ)
    assign sum = a ^ b;
    
    // Carry-out is AND of inputs (1 when both inputs are 1)
    assign cout = a & b;

endmodule