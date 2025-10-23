module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Conditions for q to be 1
    wire cond1, cond2, cond3, cond4;
    
    // One input is 1, and the others are 0
    assign cond1 = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d);
    
    // Three inputs are 1, and one is 0
    assign cond2 = (a & b & c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) | (~a & b & c & d);
    
    // All inputs are 0
    assign cond3 = ~a & ~b & ~c & ~d;
    
    // Combine conditions for q to be 1
    assign q = cond1 | cond2 | cond3;

endmodule