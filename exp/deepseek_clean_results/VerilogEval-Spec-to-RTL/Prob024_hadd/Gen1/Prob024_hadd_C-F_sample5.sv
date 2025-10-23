module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);
    // Sum is 1 when inputs are different (XOR)
    assign sum = a ^ b;
    
    // Carry-out is 1 only when both inputs are 1 (AND)
    assign cout = a & b;
endmodule