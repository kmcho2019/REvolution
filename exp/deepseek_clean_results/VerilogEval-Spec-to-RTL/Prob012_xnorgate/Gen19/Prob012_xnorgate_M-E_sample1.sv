module TopModule (
    input a,
    input b,
    output out
);
    // Internal nodes for complementary logic
    wire pullup, pulldown;
    wire a_n = ~a;
    wire b_n = ~b;
    
    // Pull-up conditions: (a AND b) OR (NOT a AND NOT b)
    assign pullup = (a & b) | (a_n & b_n);
    
    // Pull-down condition: (a XOR b)
    assign pulldown = a ^ b;
    
    // Transmission gate style output
    assign out = pullup ? 1'b1 : (pulldown ? 1'b0 : 1'bz);
    
    // Final resolution (in case both paths are off)
    assign out = (out === 1'bz) ? 1'b0 : out;
endmodule