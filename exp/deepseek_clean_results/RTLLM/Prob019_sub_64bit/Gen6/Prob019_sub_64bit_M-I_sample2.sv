module sub_64bit (
    input clk,
    input clk_en,
    input rst_n,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg [15:0] A_stage1, B_stage1;
    reg [15:0] A_stage2, B_stage2, res_stage1;
    reg [15:0] A_stage3, B_stage3, res_stage2;
    reg [15:0] A_stage4, B_stage4, res_stage3;
    reg carry_stage1, carry_stage2, carry_stage3;
    reg A_sign_stage1, B_sign_stage1;
    reg A_sign_stage2, B_sign_stage2;
    reg A_sign_stage3, B_sign_stage3;
    reg A_sign_stage4, B_sign_stage4;

    // Internal signals
    wire [15:0] res_stage0;
    wire carry_stage0;
    wire [15:0] res_stage1_w, res_stage2_w, res_stage3_w, res_stage4_w;
    wire carry_stage1_w, carry_stage2_w, carry_stage3_w, carry_stage4_w;

    // Stage 0: LSB 16 bits
    cla_subtractor_16bit sub0 (
        .A(A[15:0]),
        .B(B[15:0]),
        .cin(1'b1),  // For two's complement subtraction
        .sum(res_stage0),
        .cout(carry_stage0)
    );

    // Stage 1: Next 16 bits
    cla_subtractor_16bit sub1 (
        .A(A_stage1),
        .B(B_stage1),
        .cin(carry_stage1),
        .sum(res_stage1_w),
        .cout(carry_stage1_w)
    );

    // Stage 2: Next 16 bits
    cla_subtractor_16bit sub2 (
        .A(A_stage2),
        .B(B_stage2),
        .cin(carry_stage2),
        .sum(res_stage2_w),
        .cout(carry_stage2_w)
    );

    // Stage 3: Next 16 bits
    cla_subtractor_16bit sub3 (
        .A(A_stage3),
        .B(B_stage3),
        .cin(carry_stage3),
        .sum(res_stage3_w),
        .cout(carry_stage3_w)
    );

    // Stage 4: MSB 16 bits
    cla_subtractor_16bit sub4 (
        .A(A_stage4),
        .B(B_stage4),
        .cin(carry_stage4),
        .sum(res_stage4_w),
        .cout(carry_stage4_w)
    );

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            {A_stage1, B_stage1, A_sign_stage1, B_sign_stage1} <= 0;
            {A_stage2, B_stage2, res_stage1, carry_stage1, A_sign_stage2, B_sign_stage2} <= 0;
            {A_stage3, B_stage3, res_stage2, carry_stage2, A_sign_stage3, B_sign_stage3} <= 0;
            {A_stage4, B_stage4, res_stage3, carry_stage3, A_sign_stage4, B_sign_stage4} <= 0;
            {result, overflow} <= 0;
        end
        else if (clk_en) begin
            // Stage 1 registers
            A_stage1 <= A[31:16];
            B_stage1 <= B[31:16];
            carry_stage1 <= carry_stage0;
            A_sign_stage1 <= A[63];
            B_sign_stage1 <= B[63];

            // Stage 2 registers
            A_stage2 <= A[47:32];
            B_stage2 <= B[47:32];
            res_stage1 <= res_stage0;
            carry_stage2 <= carry_stage1_w;
            A_sign_stage2 <= A_sign_stage1;
            B_sign_stage2 <= B_sign_stage1;

            // Stage 3 registers
            A_stage3 <= A[63:48];
            B_stage3 <= B[63:48];
            res_stage2 <= res_stage1_w;
            carry_stage3 <= carry_stage2_w;
            A_sign_stage3 <= A_sign_stage2;
            B_sign_stage3 <= B_sign_stage2;

            // Stage 4 registers
            res_stage3 <= res_stage2_w;
            carry_stage4 <= carry_stage3_w;
            A_sign_stage4 <= A_sign_stage3;
            B_sign_stage4 <= B_sign_stage3;

            // Output registers
            result <= {res_stage4_w, res_stage3, res_stage2, res_stage1};
            overflow <= (A_sign_stage4 != B_sign_stage4) && (A_sign_stage4 != res_stage4_w[15]);
        end
    end

endmodule

// 16-bit carry-lookahead subtractor module
module cla_subtractor_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] sum,
    output cout
);
    // Implementation of 16-bit carry-lookahead subtractor
    // (Actual CLA logic would go here)
    wire [15:0] B_comp = ~B;
    assign {cout, sum} = A + B_comp + cin;
endmodule