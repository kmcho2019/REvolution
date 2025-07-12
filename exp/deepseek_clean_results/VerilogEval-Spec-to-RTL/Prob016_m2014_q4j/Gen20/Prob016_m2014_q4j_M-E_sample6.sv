module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] p;  // Propagate signals
    wire [3:0] g;  // Generate signals
    wire [3:0] c;  // Carry chain
    
    // Compute propagate and generate in parallel
    assign p = x ^ y;
    assign g = x & y;
    
    // Carry chain with skip logic
    assign c[0] = g[0] | (p[0] & 1'b0);  // Initial carry-in is 0
    
    // Skip logic for bits 1-2
    wire skip1 = p[1] & p[0];
    assign c[1] = skip1 ? c[0] : (g[1] | (p[1] & c[0]));
    
    wire skip2 = p[2] & p[1];
    assign c[2] = skip2 ? c[1] : (g[2] | (p[2] & c[1]));
    
    // MSB with overflow handling
    assign c[3] = g[3] | (p[3] & c[2]);
    
    // Sum computation
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c[0];
    assign sum[2] = p[2] ^ c[1];
    assign sum[3] = p[3] ^ c[2];
    assign sum[4] = c[3];  // Overflow bit
endmodule