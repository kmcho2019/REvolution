module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain with lookahead for first 4 bits
    wire [WIDTH:0] carry;
    assign carry[0] = cin;
    
    // Lookahead carry computation for first 4 bits (reduces critical path)
    wire [3:0] g, p;  // Generate and propagate signals
    wire [3:0] c;     // Lookahead carries
    
    // Generate and propagate for first 4 bits
    assign g = a[3:0] & b[3:0];
    assign p = a[3:0] | b[3:0];
    
    // Lookahead carry computation
    assign c[0] = g[0] | (p[0] & carry[0]);
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                 (p[2] & p[1] & p[0] & carry[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                 (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & carry[0]);
    
    // Assign lookahead carries
    assign carry[1] = c[0];
    assign carry[2] = c[1];
    assign carry[3] = c[2];
    assign carry[4] = c[3];
    
    // Ripple-carry for remaining bits (better area tradeoff)
    genvar i;
    generate
        for (i = 4; i < WIDTH; i = i + 1) begin : ripple_adder
            // Optimized majority function implementation
            wire g_i = a[i] & b[i];
            wire p_i = a[i] | b[i];
            assign carry[i+1] = g_i | (p_i & carry[i]);
            
            // Sum computation
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate
    
    // Sum computation for first 4 bits
    assign sum[3:0] = a[3:0] ^ b[3:0] ^ {carry[3], carry[2], carry[1], carry[0]};
    
    // Final carry out
    assign cout = carry[WIDTH];

    // Operand isolation (optional power optimization)
    // When inputs are static, this prevents unnecessary switching
    // Requires enable signal from higher level in actual implementation
    // wire adder_enable = 1'b1;  // Would come from control logic
    
endmodule