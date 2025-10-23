module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zeros at MSB side (shifted left by size bits)
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // --- Stage 1 registers: register extended multiplicand and multiplier ---
    reg [2*size-1:0] stage1_ext_mul_a;
    reg [size-1:0]   stage1_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_ext_mul_a <= 0;
            stage1_mul_b <= 0;
        end else begin
            stage1_ext_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
        end
    end

    // --- Stage 2: compute partial sums of bits 0 and 1 of multiplier ---
    // partial products for bit 0 and bit 1
    wire [2*size-1:0] pp_bit0 = (stage1_mul_b[0]) ? (stage1_ext_mul_a << 0) : 0;
    wire [2*size-1:0] pp_bit1 = (stage1_mul_b[1]) ? (stage1_ext_mul_a << 1) : 0;

    wire [2*size-1:0] sum_stage2 = pp_bit0 + pp_bit1;

    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
        end else begin
            stage2_sum <= sum_stage2;
        end
    end

    // --- Stage 3: compute partial sums of bits 2 and 3 and add to stage2_sum ---
    wire [2*size-1:0] pp_bit2 = (stage1_mul_b[2]) ? (stage1_ext_mul_a << 2) : 0;
    wire [2*size-1:0] pp_bit3 = (stage1_mul_b[3]) ? (stage1_ext_mul_a << 3) : 0;

    wire [2*size-1:0] sum_stage3 = pp_bit2 + pp_bit3 + stage2_sum;

    // Output register: holds final product after two pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage3;
        end
    end

endmodule