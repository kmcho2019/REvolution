module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Efficient conditional partial product generation
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? {{8{1'b0}}, A} << i : 16'b0;
        end
    endgenerate

    // First stage: 4:2 compressor for better area efficiency
    wire [15:0] sum1, carry1;
    compressor_4to2 stage1 (
        .in0(pp[0]),
        .in1(pp[1]),
        .in2(pp[2]),
        .in3(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second stage: Optimized CSA tree
    wire [15:0] sum2, carry2;
    csa_16bit stage2 (
        .a(sum1),
        .b({carry1[14:0], 1'b0}),
        .c(pp[4]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third stage: Combine remaining terms
    wire [15:0] sum3 = sum2 + {carry2[14:0], 1'b0} + pp[5];
    wire [15:0] sum4 = pp[6] + pp[7];

    // Final addition with carry-select adder (better area-performance tradeoff)
    carry_select_16bit final_adder (
        .a(sum3),
        .b(sum4),
        .sum(product)
    );

endmodule

// Optimized 4:2 compressor
module compressor_4to2(
    input [15:0] in0,
    input [15:0] in1,
    input [15:0] in2,
    input [15:0] in3,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = in0 ^ in1 ^ in2;
    wire [15:0] c1 = (in0 & in1) | (in0 & in2) | (in1 & in2);
    
    assign sum = s1 ^ in3 ^ {c1[14:0], 1'b0};
    assign carry = (s1 & in3) | (s1 & {c1[14:0], 1'b0}) | (in3 & {c1[14:0], 1'b0});
endmodule

// Carry-select adder (better area for 16-bit than CLA)
module carry_select_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire [7:0] sum_low, sum_high0, sum_high1;
    wire cout_low;
    
    // Lower 8 bits with ripple carry
    adder_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );
    
    // Upper 8 bits - calculate both possibilities
    adder_8bit high_adder0 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b0),
        .sum(sum_high0),
        .cout()
    );
    
    adder_8bit high_adder1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(1'b1),
        .sum(sum_high1),
        .cout()
    );
    
    // Mux final result based on lower carry
    assign sum = {cout_low ? sum_high1 : sum_high0, sum_low};
endmodule

// Basic 8-bit adder for carry-select
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

// Optimized CSA module with bit-width awareness
module csa_16bit(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    // Only compute relevant bits to save power
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule