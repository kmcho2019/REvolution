module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

// Implement the logic for each group in the Karnaugh map
always @(a, b, c, d) begin
    // Group 1: ab = 00, cd = 00 or cd = 10
    reg group1;
    group1 = (~a & ~b & (~c & ~d | ~c & d));
    
    // Group 2: ab = 00, cd = 01
    reg group2;
    group2 = (~a & ~b & c & ~d);
    
    // Group 3: ab = 01, cd = 00 or cd = 01 or cd = 11
    reg group3;
    group3 = (~a & b & (~c & ~d | c & ~d | c & d));
    
    // Group 4: ab = 10, cd = 00 or cd = 01
    reg group4;
    group4 = (a & ~b & (~c & ~d | c & ~d));
    
    // Group 5: ab = 11, cd = 01 or cd = 11
    reg group5;
    group5 = (a & b & (c & ~d | c & d));
    
    // Combine the groups using OR gates
    out = group1 | group2 | group3 | group4 | group5;
end

endmodule