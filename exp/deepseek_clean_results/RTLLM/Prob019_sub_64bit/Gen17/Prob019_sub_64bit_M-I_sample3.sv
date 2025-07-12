module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    input clk,          // Added for clock gating
    input en,           // Enable signal
    output signed [63:0] result,
    output overflow
);

    // Clock-gated complement logic
    reg [63:0] B_comp;
    always @(posedge clk) begin
        if (en) B_comp <= ~B;
    end

    // Hierarchical 8-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            // Block propagate and generate (Manchester style)
            wire [7:0] p = A[i+:8] ^ B_comp[i+:8];
            wire [7:0] g = A[i+:8] & B_comp[i+:8];
            
            // Shared terms for carry computation
            wire [7:0] carry;
            wire cin = (i == 0) ? 1'b1 : carry[i-1];
            
            // Manchester carry chain implementation
            assign carry[0] = (p[0] & cin) | g[0];
            assign carry[1] = (p[1] & carry[0]) | g[1];
            assign carry[2] = (p[2] & carry[1]) | g[2];
            assign carry[3] = (p[3] & carry[2]) | g[3];
            assign carry[4] = (p[4] & carry[3]) | g[4];
            assign carry[5] = (p[5] & carry[4]) | g[5];
            assign carry[6] = (p[6] & carry[5]) | g[6];
            assign carry[7] = (p[7] & carry[6]) | g[7];
            
            // Sum computation with local carry signals
            assign result[i]   = p[0] ^ cin;
            assign result[i+1] = p[1] ^ carry[0];
            assign result[i+2] = p[2] ^ carry[1];
            assign result[i+3] = p[3] ^ carry[2];
            assign result[i+4] = p[4] ^ carry[3];
            assign result[i+5] = p[5] ^ carry[4];
            assign result[i+6] = p[6] ^ carry[5];
            assign result[i+7] = p[7] ^ carry[6];
        end
    endgenerate

    // Optimized overflow detection
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = result[63];
    assign overflow = (~sign_A & sign_B & sign_R) | (sign_A & ~sign_B & ~sign_R);

endmodule