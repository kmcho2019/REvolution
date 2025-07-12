module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] gen = a & b;
    wire [7:0] prop = a ^ b;
    
    // Carry computation (4-bit blocks with full unrolling)
    wire [7:0] carry;
    
    // First 4-bit block
    assign carry[0] = gen[0];
    assign carry[1] = gen[1] | (prop[1] & carry[0]);
    assign carry[2] = gen[2] | (prop[2] & carry[1]);
    assign carry[3] = gen[3] | (prop[3] & carry[2]);
    
    // Second 4-bit block
    assign carry[4] = gen[4] | (prop[4] & carry[3]);
    assign carry[5] = gen[5] | (prop[5] & carry[4]);
    assign carry[6] = gen[6] | (prop[6] & carry[5]);
    assign carry[7] = gen[7] | (prop[7] & carry[6]);
    
    // Sum computation
    assign s = prop ^ {carry[6:0], 1'b0};
    
    // Overflow detection (sign bits comparison - more accurate)
    assign overflow = (a[7] == b[7]) & (a[7] != s[7]);
endmodule