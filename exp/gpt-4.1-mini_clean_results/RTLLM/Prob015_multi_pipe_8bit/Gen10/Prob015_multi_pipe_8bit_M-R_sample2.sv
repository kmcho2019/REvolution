module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1: input registers and partial product generation
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_stage1;

    // Partial products wires (16 bits each)
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2: sum partial products progressively and register
    // Partial sums intermediate registers
    reg [15:0] sum_0_3; // sum of pp[0] to pp[3]
    reg [15:0] sum_4_7; // sum of pp[4] to pp[7]
    reg        mul_en_stage2;

    // Stage 3: final product register
    reg [15:0] final_sum;
    reg        mul_en_stage3;

    // Pipeline stage 1: latch inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_stage1 <= mul_en_in;
        end
    end

    // Stage 2 combinational sums of partial products groups
    wire [15:0] sum_lower = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_upper = pp[4] + pp[5] + pp[6] + pp[7];

    // Pipeline stage 2: register partial sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_3 <= 16'd0;
            sum_4_7 <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            sum_0_3 <= sum_lower;
            sum_4_7 <= sum_upper;
            mul_en_stage2 <= mul_en_stage1;
        end
    end

    // Stage 3 combinational final sum
    wire [15:0] final_sum_comb = sum_0_3 + sum_4_7;

    // Pipeline stage 3: register final product and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            final_sum <= final_sum_comb;
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'd0;
            mul_en_out <= 1'b0;
        end else begin
            mul_out <= mul_en_stage3 ? final_sum : 16'd0;
            mul_en_out <= mul_en_stage3;
        end
    end

endmodule