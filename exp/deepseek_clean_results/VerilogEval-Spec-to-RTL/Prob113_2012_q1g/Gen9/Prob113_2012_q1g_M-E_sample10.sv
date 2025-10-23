module TopModule(
    input [3:0] x,
    output f
);
    // Group 1: x[3]x[2]x[1]x[0] = 00-0
    wire group1 = ~x[3] & ~x[2] & ~x[0];
    
    // Group 2: x[3]x[2]x[1]x[0] = 11--
    wire group2 = x[3] & x[2];
    
    // Group 3: x[3]x[2]x[1]x[0] = 100-
    wire group3 = x[3] & ~x[2] & ~x[1];
    
    // Group 4: x[3]x[2]x[1]x[0] = 1011
    wire group4 = x[3] & ~x[2] & x[1] & x[0];
    
    // Combine all groups
    assign f = group1 | group2 | group3 | group4;
endmodule