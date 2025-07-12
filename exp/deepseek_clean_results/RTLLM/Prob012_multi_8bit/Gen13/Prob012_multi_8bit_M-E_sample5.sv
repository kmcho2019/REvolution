module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Stage 1: Generate and conditionally select partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Stage 2: Binary tree of adders (level 1)
    wire [15:0] sum_l1 [3:0];
    wire [15:0] carry_l1 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level1_adders
            adder_16bit adder (
                .a(pp[2*i]),
                .b(pp[2*i+1]),
                .sum(sum_l1[i]),
                .cout(carry_l1[i])
            );
        end
    endgenerate

    // Stage 3: Binary tree of adders (level 2)
    wire [15:0] sum_l2 [1:0];
    wire [15:0] carry_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level2_adders
            adder_16bit adder (
                .a(sum_l1[2*i] + {carry_l1[2*i][14:0], 1'b0}),
                .b(sum_l1[2*i+1] + {carry_l1[2*i+1][14:0], 1'b0}),
                .sum(sum_l2[i]),
                .cout(carry_l2[i])
            );
        end
    endgenerate

    // Stage 4: Final addition
    wire [15:0] final_sum;
    wire [15:0] final_carry;
    adder_16bit final_adder (
        .a(sum_l2[0] + {carry_l2[0][14:0], 1'b0}),
        .b(sum_l2[1] + {carry_l2[1][14:0], 1'b0}),
        .sum(product),
        .cout()  // Ignore final carry-out
    );

endmodule

// Optimized 16-bit adder with carry-propagate
module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum,
    output cout
);
    wire [16:0] c;
    assign c[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bit_adder
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate
    
    assign cout = c[16];
endmodule