module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Generate partial products (16-bit wires), A shifted by bit position i if B[i] == 1
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = B[i] ? ({{8{1'b0}}, A} << i) : 16'b0;
            // Note: zero-extend A to 16 bits before shift to avoid truncation
        end
    endgenerate

    // Carry-Save Addition (CSA) function for three 16-bit inputs
    function automatic [31:0] csa_16;
        input [15:0] x;
        input [15:0] y;
        input [15:0] z;
        reg   [15:0] sum;    // bitwise XOR
        reg   [15:0] carry;  // bitwise majority, shifted left by 1
        begin
            sum = x ^ y ^ z;
            carry = ((x & y) | (y & z) | (x & z)) << 1;
            csa_16 = {carry, sum}; // upper 16: carry, lower 16: sum
        end
    endfunction

    // First stage: combine partial products in groups of three with CSA
    // We have 8 partial products; group them as (0,1,2), (3,4,5), (6,7,0 zero padded)
    // For (6,7), pad with zero partial product (0) to make three inputs.
    wire [31:0] csa_out0, csa_out1, csa_out2;

    assign csa_out0 = csa_16(partial_products[0], partial_products[1], partial_products[2]);
    assign csa_out1 = csa_16(partial_products[3], partial_products[4], partial_products[5]);
    assign csa_out2 = csa_16(partial_products[6], partial_products[7], 16'b0);

    // Extract sum and carry from CSA outputs
    wire [15:0] sum0, carry0;
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;

    assign sum0   = csa_out0[15:0];
    assign carry0 = csa_out0[31:16];

    assign sum1   = csa_out1[15:0];
    assign carry1 = csa_out1[31:16];

    assign sum2   = csa_out2[15:0];
    assign carry2 = csa_out2[31:16];

    // Second stage: sum the six outputs from first CSA stage (sum0, carry0, sum1, carry1, sum2, carry2)
    // Again use CSA to add these six operands in two groups of three
    wire [31:0] csa_out3, csa_out4;
    assign csa_out3 = csa_16(sum0, carry0, sum1);
    assign csa_out4 = csa_16(carry1, sum2, carry2);

    wire [15:0] sum3, carry3;
    wire [15:0] sum4, carry4;

    assign sum3   = csa_out3[15:0];
    assign carry3 = csa_out3[31:16];

    assign sum4   = csa_out4[15:0];
    assign carry4 = csa_out4[31:16];

    // Third stage: add the four remaining 16-bit operands: sum3, carry3, sum4, carry4
    // Use two 16-bit adders to sum pairwise first, then final adder

    wire [15:0] sum_level1_0;
    wire [15:0] sum_level1_1;
    wire [15:0] final_sum;
    wire [15:0] final_carry;

    assign sum_level1_0 = sum3 + carry3;
    assign sum_level1_1 = sum4 + carry4;

    assign {final_carry, final_sum} = {16'b0, sum_level1_0} + {sum_level1_1, 16'b0};
    // But the above assignment concatenates incorrectly; instead sum_level1_0 and sum_level1_1 are 16-bit each.

    // Correct the final addition: add sum_level1_0 + sum_level1_1 as 16-bit numbers, then handle overflow
    // Since product is 16-bit, sum_level1_0 + sum_level1_1 can produce 17 bits max
    wire [16:0] final_add;
    assign final_add = {1'b0, sum_level1_0} + {1'b0, sum_level1_1};

    // The final addition is product = final_add (17 bits), but product output is 16 bits.
    // The 17th bit can be truncated or included if desired (but max product fits in 16 bits)
    // The largest multiplication of two 8-bit numbers is 255*255=65025 (< 65536), fits in 16 bits

    assign product = final_add[15:0];

endmodule