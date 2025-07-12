module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Individual generate and propagate signals
    wire [3:0] g = x & y;
    wire [3:0] p = x ^ y;
    
    // Group propagate (all bits propagate carry)
    wire group_p = &p;
    
    // Carry computation with skip logic
    wire c0 = g[0] | (p[0] & 1'b0);
    wire c1 = g[1] | (p[1] & c0);
    wire c2 = g[2] | (p[2] & c1);
    wire c3_ripple = g[3] | (p[3] & c2);
    wire c3_skip = g[3] | (p[3] & (group_p ? 1'b0 : c2));
    
    // Final carry out (use skip when possible)
    wire cout = group_p ? 1'b0 : c3_ripple;
    
    // Sum computation
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c0;
    assign sum[2] = p[2] ^ c1;
    assign sum[3] = p[3] ^ c2;
    assign sum[4] = cout;
endmodule