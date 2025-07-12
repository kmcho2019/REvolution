module TopModule(
    input [3:0] x,
    output f
);
    // Group A: x3x2x1x0 = 00-0
    wire groupA = ~x[3] & ~x[2] & ~x[0];
    
    // Group B+C: x3x2x1x0 = 11-0 or 110-
    wire groupBC = x[3] & x[2] & (~x[0] | ~x[1]);
    
    // Group D: x3x2x1x0 = 10--
    wire groupD = x[3] & ~x[2];
    
    // Combine all groups
    assign f = groupA | groupBC | groupD;
endmodule