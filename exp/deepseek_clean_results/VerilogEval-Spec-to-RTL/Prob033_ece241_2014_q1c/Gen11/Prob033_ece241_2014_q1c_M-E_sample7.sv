module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Split into 2-bit blocks
    wire [3:0] block_carry;
    wire [3:0] block_propagate;
    wire [3:0] block_generate;
    
    // Process each 2-bit block
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : blocks
            // Block index range
            localparam hi = i*2+1;
            localparam lo = i*2;
            
            // Block-level generate/propagate
            wire g0 = a[lo] & b[lo];
            wire p0 = a[lo] ^ b[lo];
            wire g1 = a[hi] & b[hi];
            wire p1 = a[hi] ^ b[hi];
            
            // Block carry computation
            assign block_generate[i] = g1 | (p1 & g0);
            assign block_propagate[i] = p1 & p0;
            
            // Block sum computation
            wire cin = (i == 0) ? 1'b0 : block_carry[i-1];
            wire c0 = g0 | (p0 & cin);
            assign s[lo] = p0 ^ cin;
            assign s[hi] = p1 ^ c0;
            
            // Block carry out
            assign block_carry[i] = block_generate[i] | 
                                 (block_propagate[i] & ((i == 0) ? 1'b0 : block_carry[i-1]));
        end
    endgenerate
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = s[7];
    wire carry_in_to_msb = block_carry[2];
    wire carry_out_msb = block_carry[3];
    
    // Overflow occurs if:
    // 1. Signs of inputs are same
    // 2. Sign of result differs from input signs
    // 3. Carry into MSB differs from carry out of MSB
    assign overflow = (sign_a == sign_b) && 
                     ((sign_sum != sign_a) || 
                     (carry_in_to_msb != carry_out_msb));
endmodule