module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Conditional partial product generation with zero detection
    wire [15:0] pp [7:0];
    wire [7:0] B_mask = B;
    
    assign pp[0] = B_mask[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B_mask[1] ? {7'b0, A, 1'b0} : 16'b0;
    assign pp[2] = B_mask[2] ? {6'b0, A, 2'b0} : 16'b0;
    assign pp[3] = B_mask[3] ? {5'b0, A, 3'b0} : 16'b0;
    assign pp[4] = B_mask[4] ? {4'b0, A, 4'b0} : 16'b0;
    assign pp[5] = B_mask[5] ? {3'b0, A, 5'b0} : 16'b0;
    assign pp[6] = B_mask[6] ? {2'b0, A, 6'b0} : 16'b0;
    assign pp[7] = B_mask[7] ? {1'b0, A, 7'b0} : 16'b0;

    // First level 4:2 compressor reduction
    wire [15:0] sum1, carry1;
    compressor_4to2 level1_comp (
        .in1(pp[0]),
        .in2(pp[1]),
        .in3(pp[2]),
        .in4(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second level 4:2 compressor reduction
    wire [15:0] sum2, carry2;
    compressor_4to2 level2_comp (
        .in1(pp[4]),
        .in2(pp[5]),
        .in3(pp[6]),
        .in4(pp[7]),
        .sum(sum2),
        .carry(carry2)
    );

    // Final reduction and addition
    wire [15:0] sum3 = sum1 + (carry1 << 1);
    wire [15:0] sum4 = sum2 + (carry2 << 1);
    
    // Hybrid final adder (carry-select for lower bits, carry-lookahead for upper)
    hybrid_adder final_adder (
        .a(sum3),
        .b(sum4),
        .sum(product)
    );

endmodule

// 4:2 compressor module (more efficient than 3:2 CSA)
module compressor_4to2 (
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    input [15:0] in4,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = in1 ^ in2;
    wire [15:0] c1 = in1 & in2;
    
    wire [15:0] s2 = s1 ^ in3;
    wire [15:0] c2 = (s1 & in3) | c1;
    
    assign sum = s2 ^ in4;
    assign carry = (s2 & in4) | c2;
endmodule

// Hybrid adder (carry-select for bits 0-7, carry-lookahead for bits 8-15)
module hybrid_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    // Lower bits: carry-select adder
    wire [7:0] sum_low_0 = a[7:0] + b[7:0];
    wire [7:0] sum_low_1 = a[7:0] + b[7:0] + 1'b1;
    
    wire c7 = (a[7:0] + b[7:0])[8];
    wire [7:0] sum_low = c7 ? sum_low_1 : sum_low_0;
    
    // Upper bits: carry-lookahead adder
    wire [7:0] p = a[15:8] ^ b[15:8];
    wire [7:0] g = a[15:8] & b[15:8];
    
    wire [8:0] carry;
    assign carry[0] = c7;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
            assign sum[8+i] = p[i] ^ carry[i];
        end
    endgenerate
    
    assign sum[7:0] = sum_low;
endmodule