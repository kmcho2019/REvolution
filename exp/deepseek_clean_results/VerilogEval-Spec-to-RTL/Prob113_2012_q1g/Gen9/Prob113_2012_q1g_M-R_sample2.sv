module TopModule(
    input [3:0] x,
    output f
);
    // Declare all wires explicitly
    wire row00, row01, row11, row10;
    wire x0_n, x1_n;
    wire x0, x1;
    
    // Assign inverted and non-inverted signals
    assign x0 = x[0];
    assign x1 = x[1];
    assign x0_n = ~x[0];
    assign x1_n = ~x[1];
    
    // Row 00: x[3:2] = 00
    assign row00 = (~x[3] & ~x[2]) & (
        (x1_n & x0_n) |  // 00
        (x1 & x0_n)      // 10
    );
    
    // Row 01: x[3:2] = 01 (all zeros)
    assign row01 = 1'b0;
    
    // Row 11: x[3:2] = 11
    assign row11 = (x[3] & x[2]) & (
        (x1_n & x0_n) |  // 00
        (x1_n & x0) |     // 01
        (x1 & x0)        // 11
    );
    
    // Row 10: x[3:2] = 10
    assign row10 = (x[3] & ~x[2]) & (
        (x1_n & x0_n) |  // 00
        (x1_n & x0) |     // 01
        (x1 & x0_n)       // 10
    );
    
    // Final output
    assign f = row00 | row01 | row11 | row10;
endmodule