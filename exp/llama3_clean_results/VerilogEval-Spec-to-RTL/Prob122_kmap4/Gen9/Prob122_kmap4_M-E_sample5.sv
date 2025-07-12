module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Quadrant cd = 00
    wire q00 = ~c & ~d & (a ^ b);
    
    // Quadrant cd = 01
    wire q01 = ~c & d & ~(a ^ b);
    
    // Quadrant cd = 11
    wire q11 = c & d & (a ^ b);
    
    // Quadrant cd = 10
    wire q10 = c & ~d & ~(a ^ b);
    
    // Final output
    assign out = q00 | q01 | q11 | q10;

endmodule