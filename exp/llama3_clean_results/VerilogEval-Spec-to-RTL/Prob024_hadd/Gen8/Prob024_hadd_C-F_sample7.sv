module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);
    
    // Utilizing XOR for sum and AND for carry-out as these operations are optimal for a half adder
    assign sum = a ^ b;  
    assign cout = a & b;  
    
endmodule