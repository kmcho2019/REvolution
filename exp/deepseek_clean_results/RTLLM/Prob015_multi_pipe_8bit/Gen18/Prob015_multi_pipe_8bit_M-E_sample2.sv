module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [15:0] stage1_pp [3:0];  // Booth-encoded partial products
    reg [15:0] final_sum;
    reg output_valid;

    // Booth encoding (combinational)
    wire [8:0] b_ext = {mul_b, 1'b0};  // Extended multiplier for Booth
    wire [15:0] booth_pp [3:0];
    wire [15:0] a_neg = -{8'b0, mul_a};
    wire [15:0] a_2x = {7'b0, mul_a, 1'b0};
    wire [15:0] a_neg_2x = -{7'b0, mul_a, 1'b0};

    // Generate Booth-encoded partial products
    generate
        for (genvar i = 0; i < 4; i = i + 1) begin : booth_pp_gen
            wire [2:0] booth_sel = b_ext[i*2+2:i*2];
            always @(*) begin
                case (booth_sel)
                    3'b000, 3'b111: stage1_pp[i] = 16'b0;
                    3'b001, 3'b010: stage1_pp[i] = {8'b0, mul_a} << (i*2);
                    3'b011:         stage1_pp[i] = a_2x << (i*2);
                    3'b100:         stage1_pp[i] = a_neg_2x << (i*2);
                    3'b101, 3'b110: stage1_pp[i] = a_neg << (i*2);
                endcase
            end
        end
    endgenerate

    // Wallace tree compression (4:2 compressors)
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    wire [15:0] final_add;

    // First level of compression
    csa_4to2 csa1 (
        .a(stage1_pp[0]),
        .b(stage1_pp[1]),
        .c(stage1_pp[2]),
        .d(stage1_pp[3]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second level (final addition)
    assign final_add = sum1 + (carry1 << 1);

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'b0;
            output_valid <= 1'b0;
        end else begin
            // Stage 1: Booth encoding happens in always @(*) above
            // Stage 2: Final addition
            final_sum <= final_add;
            output_valid <= mul_en_in;
        end
    end

    // Output assignments
    assign mul_en_out = output_valid;
    assign mul_out = output_valid ? final_sum : 16'b0;

endmodule

// 4:2 Compressor module
module csa_4to2 (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [15:0] c,
    input wire [15:0] d,
    output wire [15:0] sum,
    output wire [15:0] carry
);
    wire [15:0] sum_ab = a ^ b;
    wire [15:0] carry_ab = a & b;
    
    wire [15:0] sum_abc = sum_ab ^ c;
    wire [15:0] carry_abc = (sum_ab & c) | carry_ab;
    
    assign sum = sum_abc ^ d;
    assign carry = (sum_abc & d) | carry_abc;
endmodule