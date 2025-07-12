module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire partial_sum, carry1, carry2;
    
    // First half adder (a + b)
    assign partial_sum = a ^ b;
    assign carry1 = a & b;
    
    // Second half adder (partial_sum + cin)
    assign sum = partial_sum ^ cin;
    assign carry2 = partial_sum & cin;
    
    // Final carry out
    assign cout = carry1 | carry2;
endmodule