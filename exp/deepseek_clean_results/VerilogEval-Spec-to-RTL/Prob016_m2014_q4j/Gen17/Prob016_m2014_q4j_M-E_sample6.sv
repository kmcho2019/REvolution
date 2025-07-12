module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Block 0 signals (bits 0-1)
    wire p0, p1;          // Individual propagate signals
    wire g0, g1;          // Individual generate signals
    wire cout0;           // Block 0 carry-out
    wire block0_propagate; // Block propagate signal
    
    // Block 1 signals (bits 2-3)
    wire p2, p3;          // Individual propagate signals
    wire g2, g3;          // Individual generate signals
    wire cout1;           // Block 1 carry-out
    wire block1_propagate; // Block propagate signal
    
    // Final carry signals
    wire carry_skip;
    wire final_carry;
    
    // Block 0 calculations (bits 0-1)
    assign p0 = x[0] ^ y[0];
    assign g0 = x[0] & y[0];
    assign sum[0] = p0;  // cin=0 for first bit
    
    assign p1 = x[1] ^ y[1];
    assign g1 = x[1] & y[1];
    assign sum[1] = p1 ^ (g0 | (p0 & 1'b0));
    
    assign cout0 = g1 | (p1 & g0) | (p1 & p0 & 1'b0);
    assign block0_propagate = p0 & p1;
    
    // Block 1 calculations (bits 2-3)
    assign p2 = x[2] ^ y[2];
    assign g2 = x[2] & y[2];
    assign sum[2] = p2 ^ cout0;
    
    assign p3 = x[3] ^ y[3];
    assign g3 = x[3] & y[3];
    assign sum[3] = p3 ^ (g2 | (p2 & cout0));
    
    assign cout1 = g3 | (p3 & g2) | (p3 & p2 & cout0);
    assign block1_propagate = p2 & p3;
    
    // Carry skip logic
    assign carry_skip = block0_propagate ? cout1 : cout0;
    assign final_carry = block1_propagate ? carry_skip : cout1;
    
    // Final output
    assign sum[4] = final_carry;
endmodule