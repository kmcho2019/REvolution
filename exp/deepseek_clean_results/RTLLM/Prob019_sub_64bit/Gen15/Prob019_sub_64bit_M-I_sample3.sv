module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] sum;
    wire [15:0] group_propagate;
    wire [15:0] group_generate;
    wire [16:0] carry;

    assign carry[0] = 1'b1; // +1 for two's complement

    // 4-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : CLA_BLOCKS
            // Bit-level propagate and generate
            wire [3:0] p = A[i*4 +:4] ^ B_comp[i*4 +:4];
            wire [3:0] g = A[i*4 +:4] & B_comp[i*4 +:4];
            
            // Group propagate and generate
            assign group_propagate[i] = &p;
            assign group_generate[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                                      (p[3] & p[2] & p[1] & g[0]);
            
            // Carry lookahead
            assign carry[i+1] = group_generate[i] | (group_propagate[i] & carry[i]);
            
            // Sum calculation
            assign sum[i*4]   = p[0] ^ carry[i];
            assign sum[i*4+1] = p[1] ^ (g[0] | (p[0] & carry[i]));
            assign sum[i*4+2] = p[2] ^ (g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[i]));
            assign sum[i*4+3] = p[3] ^ (g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                                      (p[2] & p[1] & p[0] & carry[i])));
        end
    endgenerate

    assign result = sum;

    // Overflow detection using MSB carry-out and sign bits
    // Overflow occurs when carry[16] ^ carry[15] (sign change in MSB)
    assign overflow = carry[16] ^ carry[15];

endmodule