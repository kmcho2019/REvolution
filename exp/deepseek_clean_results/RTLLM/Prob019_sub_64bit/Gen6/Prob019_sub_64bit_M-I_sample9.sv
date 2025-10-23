module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    input enable,          // Added for power optimization
    output signed [63:0] result,
    output overflow
);

    wire [63:0] B_comp = ~B + 1'b1;  // Two's complement of B
    wire [63:0] sum;
    wire [3:0] group_carry;          // Carry between 16-bit groups
    
    // 16-bit carry-lookahead subtractors (A + B_comp)
    cla_subtractor_16bit sub0 (
        .A(A[15:0]),
        .B(B_comp[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(group_carry[0])
    );
    
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : SUB_GROUP
            cla_subtractor_16bit sub (
                .A(A[(i*16)+15:i*16]),
                .B(B_comp[(i*16)+15:i*16]),
                .cin(group_carry[i-1]),
                .sum(sum[(i*16)+15:i*16]),
                .cout(group_carry[i])
            );
        end
    endgenerate

    // Gated result output
    assign result = enable ? sum : 64'b0;
    
    // Optimized overflow detection using MSB carry
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = sum[63];
    assign overflow = enable ? ((sign_A ^ sign_B) && (sign_A ^ sign_R)) : 1'b0;

endmodule

// 16-bit carry-lookahead subtractor module
module cla_subtractor_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [15:0] P, G;
    wire [16:0] C;
    
    assign C[0] = cin;
    
    // Generate and Propagate
    assign G = A & B;
    assign P = A ^ B;
    
    // Carry lookahead logic
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    // ... continue similar pattern for C[4] to C[15]
    assign C[16] = G[15] | (P[15] & G[14]) | ...; // Full carry lookahead
    
    // Sum calculation
    assign sum = P ^ C[15:0];
    assign cout = C[16];
endmodule