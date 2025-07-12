module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Segment the multiplication into lower and upper 4-bit chunks
    wire [3:0] A_low = A[3:0];
    wire [3:0] A_high = A[7:4];
    wire [3:0] B_low = B[3:0];
    wire [3:0] B_high = B[7:4];

    // Generate partial products for lower segment (4x4)
    wire [7:0] pp_low [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : pp_low_gen
            assign pp_low[i] = ({4{B_low[i]}} & A_low) << i;
        end
    endgenerate

    // Generate partial products for upper segment (4x4)
    wire [7:0] pp_high [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : pp_high_gen
            assign pp_high[i] = ({4{B_high[i]}} & A_high) << i;
        end
    endgenerate

    // Lower segment reduction (simple adder tree)
    wire [7:0] sum_low = pp_low[0] + pp_low[1] + pp_low[2] + pp_low[3];

    // Upper segment reduction (carry-save optimized)
    wire [7:0] sum_high, carry_high;
    csa_8bit upper_reduction (
        .a(pp_high[0]),
        .b(pp_high[1]),
        .c(pp_high[2]),
        .sum(sum_high),
        .carry(carry_high)
    );
    wire [7:0] upper_result = sum_high + (carry_high << 1) + pp_high[3];

    // Cross terms (A_high * B_low and A_low * B_high)
    wire [11:0] cross_term1 = A_high * B_low;
    wire [11:0] cross_term2 = A_low * B_high;

    // Final accumulation with optimized overlapping
    wire [15:0] final_low = {8'b0, sum_low[7:0]};
    wire [15:0] final_high = {upper_result, 8'b0};
    wire [15:0] final_cross = {4'b0, cross_term1 + cross_term2, 4'b0};

    // Specialized adder that handles the 4-bit overlap efficiently
    assign product = final_low + final_high + final_cross;

endmodule

// Optimized 8-bit carry-save adder
module csa_8bit(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output [7:0] sum,
    output [7:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule