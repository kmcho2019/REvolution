module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement inversion
    wire [63:0] B_comp = ~B;
    
    // Segment definitions
    wire [7:0] sum0_0, sum0_1;
    wire [7:0] sum1_0, sum1_1;
    wire [7:0] sum2_0, sum2_1;
    wire [7:0] sum3_0, sum3_1;
    wire [7:0] sum4_0, sum4_1;
    wire [7:0] sum5_0, sum5_1;
    wire [7:0] sum6_0, sum6_1;
    wire [7:0] sum7_0, sum7_1;
    
    wire carry0, carry1, carry2, carry3;
    wire carry4, carry5, carry6, carry7;
    
    // Segment 0 (LSB)
    sub_8bit_segment seg0 (
        .A(A[7:0]),
        .B(B_comp[7:0]),
        .cin(1'b1),  // +1 for two's complement
        .sum0(sum0_0),
        .sum1(sum0_1),
        .cout0(carry0),
        .cout1()
    );
    
    // Segment 1
    sub_8bit_segment seg1 (
        .A(A[15:8]),
        .B(B_comp[15:8]),
        .cin(1'b0),
        .sum0(sum1_0),
        .sum1(sum1_1),
        .cout0(carry1),
        .cout1()
    );
    
    // Remaining segments 2-6 (similar structure)
    sub_8bit_segment seg2 (
        .A(A[23:16]),
        .B(B_comp[23:16]),
        .cin(1'b0),
        .sum0(sum2_0),
        .sum1(sum2_1),
        .cout0(carry2),
        .cout1()
    );
    
    sub_8bit_segment seg3 (
        .A(A[31:24]),
        .B(B_comp[31:24]),
        .cin(1'b0),
        .sum0(sum3_0),
        .sum1(sum3_1),
        .cout0(carry3),
        .cout1()
    );
    
    sub_8bit_segment seg4 (
        .A(A[39:32]),
        .B(B_comp[39:32]),
        .cin(1'b0),
        .sum0(sum4_0),
        .sum1(sum4_1),
        .cout0(carry4),
        .cout1()
    );
    
    sub_8bit_segment seg5 (
        .A(A[47:40]),
        .B(B_comp[47:40]),
        .cin(1'b0),
        .sum0(sum5_0),
        .sum1(sum5_1),
        .cout0(carry5),
        .cout1()
    );
    
    sub_8bit_segment seg6 (
        .A(A[55:48]),
        .B(B_comp[55:48]),
        .cin(1'b0),
        .sum0(sum6_0),
        .sum1(sum6_1),
        .cout0(carry6),
        .cout1()
    );
    
    // Segment 7 (MSB)
    sub_8bit_segment seg7 (
        .A(A[63:56]),
        .B(B_comp[63:56]),
        .cin(1'b0),
        .sum0(sum7_0),
        .sum1(sum7_1),
        .cout0(carry7),
        .cout1()
    );
    
    // Carry chain and result selection
    wire c1 = carry0;
    wire c2 = carry1 ? carry1 : c1;
    wire c3 = carry2 ? carry2 : c2;
    wire c4 = carry3 ? carry3 : c3;
    wire c5 = carry4 ? carry4 : c4;
    wire c6 = carry5 ? carry5 : c5;
    wire c7 = carry6 ? carry6 : c6;
    
    assign result[7:0] = sum0_0;  // Always use cin=1 for LSB
    
    assign result[15:8] = c1 ? sum1_1 : sum1_0;
    assign result[23:16] = c2 ? sum2_1 : sum2_0;
    assign result[31:24] = c3 ? sum3_1 : sum3_0;
    assign result[39:32] = c4 ? sum4_1 : sum4_0;
    assign result[47:40] = c5 ? sum5_1 : sum5_0;
    assign result[55:48] = c6 ? sum6_1 : sum6_0;
    assign result[63:56] = c7 ? sum7_1 : sum7_0;
    
    // Enhanced overflow detection
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = result[63];
    wire actual_cout = carry7 ? carry7 : c7;
    
    assign overflow = (sign_A ^ sign_B) & (sign_A ^ sign_R) & 
                     ((sign_A & ~sign_B & ~actual_cout) | 
                      (~sign_A & sign_B & actual_cout));

endmodule

module sub_8bit_segment (
    input [7:0] A,
    input [7:0] B,
    input cin,
    output [7:0] sum0,
    output [7:0] sum1,
    output cout0,
    output cout1
);
    // Compute both possible sums (cin=0 and cin=1)
    wire [8:0] sum_with_0 = {1'b0, A} + {1'b0, B} + {8'b0, 1'b0};
    wire [8:0] sum_with_1 = {1'b0, A} + {1'b0, B} + {8'b0, 1'b1};
    
    assign sum0 = sum_with_0[7:0];
    assign sum1 = sum_with_1[7:0];
    assign cout0 = sum_with_0[8];
    assign cout1 = sum_with_1[8];
endmodule