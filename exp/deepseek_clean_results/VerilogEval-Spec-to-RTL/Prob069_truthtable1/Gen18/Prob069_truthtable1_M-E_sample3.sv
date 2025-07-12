module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Pattern 1: x3=0 and x2=1 (binary 01)
    wire pattern1 = ~x3 & x2;
    
    // Pattern 2: x3=1 and x1=1 (binary 11)
    wire pattern2 = x3 & x1;
    
    // Output is 1 if either pattern matches
    assign f = pattern1 | pattern2;
endmodule