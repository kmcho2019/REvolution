module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline enable shift register to track valid data through pipeline stages
    reg [3:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (each 16-bit aligned)
    wire [15:0] pp [7:0];

    integer i;

    // Generate partial products: mul_a_reg AND mul_b_reg[i], shifted by i bits
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_pp
            assign pp[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Pipeline registers for sums:
    // Stage 1 sums: sum pairs of partial products into 4 sums
    reg [15:0] sum_stage1 [3:0];
    // Stage 2 sums: sum pairs of sum_stage1 into 2 sums
    reg [15:0] sum_stage2 [1:0];
    // Stage 3 sum: sum of sum_stage2 results to get final product
    reg [15:0] sum_stage3;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            sum_stage1[0] <= 16'd0;
            sum_stage1[1] <= 16'd0;
            sum_stage1[2] <= 16'd0;
            sum_stage1[3] <= 16'd0;
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage3 <= 16'd0;
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            // Shift mul_en_in into mul_en_pipe to track pipeline enable signal through stages
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            mul_en_out <= mul_en_pipe[3];

            // Sample inputs only if mul_en_in is active
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 1: sum partial products pairs
            // Only update sums when previous stage enable is active (mul_en_pipe[0])
            if (mul_en_pipe[0]) begin
                sum_stage1[0] <= pp[0] + pp[1];
                sum_stage1[1] <= pp[2] + pp[3];
                sum_stage1[2] <= pp[4] + pp[5];
                sum_stage1[3] <= pp[6] + pp[7];
            end else begin
                sum_stage1[0] <= 16'd0;
                sum_stage1[1] <= 16'd0;
                sum_stage1[2] <= 16'd0;
                sum_stage1[3] <= 16'd0;
            end

            // Stage 2: sum pairs of sums from stage 1
            // Enable check: mul_en_pipe[1]
            if (mul_en_pipe[1]) begin
                sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
                sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
            end else begin
                sum_stage2[0] <= 16'd0;
                sum_stage2[1] <= 16'd0;
            end

            // Stage 3: final sum of stage 2 sums to get product
            // Enable check: mul_en_pipe[2]
            if (mul_en_pipe[2]) begin
                sum_stage3 <= sum_stage2[0] + sum_stage2[1];
            end else begin
                sum_stage3 <= 16'd0;
            end

            // Output register
            // When mul_en_out is high (mul_en_pipe[3]), output sum_stage3, else zero
            if (mul_en_pipe[3]) begin
                mul_out <= sum_stage3;
            end else begin
                mul_out <= 16'd0;
            end
        end
    end

endmodule