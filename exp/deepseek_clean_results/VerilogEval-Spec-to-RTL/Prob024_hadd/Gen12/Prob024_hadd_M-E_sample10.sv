module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // MUX implementation for sum
    assign sum = (a ^ b) ? 1'b1 : 1'b0;
    
    // Standard AND for carry
    assign cout = a & b;

endmodule