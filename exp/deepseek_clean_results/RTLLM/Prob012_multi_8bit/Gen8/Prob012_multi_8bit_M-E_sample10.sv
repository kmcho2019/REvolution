module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Dynamic partial product generation with early zero detection
    wire [15:0] pp [7:0];
    wire [7:0] pp_valid = B;
    wire early_term = ~(|pp_valid[3:0]) & ~(|pp_valid[7:4]);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = pp_valid[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // First level of binary tree CSA reduction
    wire [15:0] sum_l1 [3:0];
    wire [15:0] carry_l1 [3:0];
    
    csa csa_l1_0 (pp[0], pp[1], pp[2], sum_l1[0], carry_l1[0]);
    csa csa_l1_1 (pp[3], pp[4], pp[5], sum_l1[1], carry_l1[1]);
    csa csa_l1_2 (pp[6], pp[7], 16'b0, sum_l1[2], carry_l1[2]);
    assign sum_l1[3] = 16'b0;
    assign carry_l1[3] = 16'b0;

    // Second level of binary tree CSA reduction
    wire [15:0] sum_l2 [1:0];
    wire [15:0] carry_l2 [1:0];
    
    csa csa_l2_0 (sum_l1[0], {carry_l1[0][14:0], 1'b0}, 
                 sum_l1[1], sum_l2[0], carry_l2[0]);
    csa csa_l2_1 (sum_l1[2], {carry_l1[1][14:0], 1'b0}, 
                 {carry_l1[2][14:0], 1'b0}, sum_l2[1], carry_l2[1]);

    // Final reduction stage
    wire [15:0] final_sum, final_carry;
    csa csa_final (sum_l2[0], {carry_l2[0][14:0], 1'b0}, 
                  sum_l2[1], final_sum, final_carry);

    // Hybrid final adder (carry-select upper bits, carry-lookahead lower bits)
    wire [15:0] final_adder_in = {carry_l2[1][14:0], 1'b0} + final_carry;
    wire [7:0] sum_low, sum_high0, sum_high1;
    wire cout_low;

    // Lower 8 bits: carry-lookahead
    cla_8bit adder_low (
        .a(final_sum[7:0]),
        .b(final_adder_in[7:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(cout_low)
    );

    // Upper 8 bits: carry-select
    cla_8bit adder_high0 (
        .a(final_sum[15:8]),
        .b(final_adder_in[15:8]),
        .cin(1'b0),
        .sum(sum_high0),
        .cout()
    );

    cla_8bit adder_high1 (
        .a(final_sum[15:8]),
        .b(final_adder_in[15:8]),
        .cin(1'b1),
        .sum(sum_high1),
        .cout()
    );

    // Output muxing
    always @(*) begin
        if (early_term) begin
            product = 16'b0;
        end else begin
            product = {cout_low ? sum_high1 : sum_high0, sum_low};
        end
    end

endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [8:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder
            wire p = a[i] ^ b[i];
            wire g = a[i] & b[i];
            assign carry[i+1] = g | (p & carry[i]);
            assign sum[i] = p ^ carry[i];
        end
    endgenerate
    
    assign cout = carry[8];
endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = {(a[14:0] & b[14:0]) | (a[14:0] & c[14:0]) | (b[14:0] & c[14:0]), 1'b0};
endmodule