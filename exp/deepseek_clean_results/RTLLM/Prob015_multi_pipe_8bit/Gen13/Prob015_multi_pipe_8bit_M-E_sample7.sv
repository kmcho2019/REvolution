module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_a;
    reg [8:0] stage1_b_ext; // Extended for Booth encoding
    reg [1:0] stage1_en;

    // Pipeline stage 2 registers
    reg [15:0] stage2_result;
    reg stage2_en;

    // Booth encoding outputs
    wire [15:0] pp0, pp1, pp2, pp3;
    wire [15:0] csa_sum, csa_carry;

    // Booth encoder (combinational)
    booth_encoder_4bit be0 (
        .a(stage1_a),
        .b_triplet({stage1_b_ext[1:0], 1'b0}),
        .pp(pp0)
    );

    booth_encoder_4bit be1 (
        .a(stage1_a),
        .b_triplet(stage1_b_ext[3:1]),
        .pp(pp1)
    );

    booth_encoder_4bit be2 (
        .a(stage1_a),
        .b_triplet(stage1_b_ext[5:3]),
        .pp(pp2)
    );

    booth_encoder_4bit be3 (
        .a(stage1_a),
        .b_triplet(stage1_b_ext[7:5]),
        .pp(pp3)
    );

    // 4:2 compressor (combinational)
    compressor_4to2 comp (
        .in0(pp0),
        .in1(pp1),
        .in2(pp2),
        .in3(pp3),
        .sum(csa_sum),
        .carry(csa_carry)
    );

    // Final adder (combinational)
    wire [15:0] final_sum = csa_sum + (csa_carry << 1);

    // Pipeline stage 1: Input registration and Booth setup
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b_ext <= 9'b0;
            stage1_en <= 2'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b_ext <= {mul_b, 1'b0}; // Sign extension for Booth
            stage1_en <= {stage1_en[0], mul_en_in};
        end
    end

    // Pipeline stage 2: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_result <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            stage2_result <= final_sum;
            stage2_en <= stage1_en[1];
        end
    end

    // Output assignments
    assign mul_en_out = stage2_en;
    assign mul_out = stage2_en ? stage2_result : 16'b0;

endmodule

// Booth encoder module for radix-4
module booth_encoder_4bit (
    input wire [7:0] a,
    input wire [2:0] b_triplet,
    output reg [15:0] pp
);

    always @(*) begin
        case (b_triplet)
            3'b000, 3'b111: pp = 16'b0;                    // 0
            3'b001, 3'b010: pp = {8'b0, a};                 // +A
            3'b011:         pp = {7'b0, a, 1'b0};           // +2A
            3'b100:         pp = {7'b0, ~a + 1'b1, 1'b0};   // -2A
            3'b101, 3'b110: pp = {8'b0, ~a + 1'b1};         // -A
            default:        pp = 16'b0;
        endcase
    end

endmodule

// 4:2 compressor module
module compressor_4to2 (
    input wire [15:0] in0,
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire [15:0] in3,
    output wire [15:0] sum,
    output wire [15:0] carry
);

    wire [15:0] s1, c1, s2, c2;

    // First level of full adders
    assign s1 = in0 ^ in1 ^ in2;
    assign c1 = ((in0 & in1) | (in1 & in2) | (in2 & in0)) << 1;

    // Second level of full adders
    assign s2 = s1 ^ in3 ^ c1;
    assign c2 = ((s1 & in3) | (in3 & c1) | (c1 & s1)) << 1;

    // Final outputs
    assign sum = s2;
    assign carry = c2;

endmodule