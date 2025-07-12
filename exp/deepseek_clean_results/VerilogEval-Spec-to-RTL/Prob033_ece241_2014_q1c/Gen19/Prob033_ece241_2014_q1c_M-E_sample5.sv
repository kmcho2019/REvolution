module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Parallel computation of generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Carry-save intermediate results
    wire [6:0] c_inter;
    
    // First stage: Compute carries for bits 0-6
    assign c_inter[0] = g[0];
    assign c_inter[1] = g[1] | (p[1] & c_inter[0]);
    assign c_inter[2] = g[2] | (p[2] & c_inter[1]);
    assign c_inter[3] = g[3] | (p[3] & c_inter[2]);
    assign c_inter[4] = g[4] | (p[4] & c_inter[3]);
    assign c_inter[5] = g[5] | (p[5] & c_inter[4]);
    assign c_inter[6] = g[6] | (p[6] & c_inter[5]);
    
    // Final carry computation for MSB
    wire c7 = g[7] | (p[7] & c_inter[6]);
    
    // Sum computation
    assign s = p ^ {c_inter[6:0], 1'b0};
    
    // Early overflow detection using sign bits
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s = s[7];
    assign overflow = (~sign_a & ~sign_b & sign_s) | (sign_a & sign_b & ~sign_s);
endmodule