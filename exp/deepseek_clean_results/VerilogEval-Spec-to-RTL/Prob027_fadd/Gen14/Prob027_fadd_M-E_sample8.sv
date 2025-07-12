module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire s1, c1, c2;
    
    // First half adder (a + b)
    assign s1 = a ^ b;
    assign c1 = a & b;
    
    // Second half adder (s1 + cin)
    assign sum = s1 ^ cin;
    assign c2 = s1 & cin;
    
    // Carry-out generation
    assign cout = c1 | c2;
endmodule