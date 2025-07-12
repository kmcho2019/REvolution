module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Hierarchical carry computation using 2-bit blocks
    wire [7:0] c;
    
    genvar i;
    generate
        // First carry bit
        assign c[0] = g[0];
        
        // Process in 2-bit blocks for balanced carry propagation
        for (i = 1; i < 8; i = i + 2) begin : carry_blocks
            // First bit in block
            assign c[i] = g[i] | (p[i] & c[i-1]);
            
            // Second bit in block (if exists)
            if (i+1 < 8) begin
                assign c[i+1] = g[i+1] | (p[i+1] & (g[i] | (p[i] & c[i-1])));
            end
        end
    endgenerate
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection (computed in parallel using carries)
    // overflow = carry_in[MSB] XOR carry_out[MSB]
    assign overflow = c[7] ^ c[6];
endmodule