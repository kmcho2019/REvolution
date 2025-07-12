module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (5 stages to match pipeline latency)
    reg [4:0] mul_en_pipe;

    // Input operand registers (stage 1)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (combinational, stage 2)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 3 registers: Pairwise sum of partial products (4 sums)
    reg [15:0] sum_stage3 [3:0];
    wire [15:0] sum_stage3_in [3:0];
    assign sum_stage3_in[0] = partial_products[0] + partial_products[1];
    assign sum_stage3_in[1] = partial_products[2] + partial_products[3];
    assign sum_stage3_in[2] = partial_products[4] + partial_products[5];
    assign sum_stage3_in[3] = partial_products[6] + partial_products[7];

    // Stage 4 registers: sum pairs from stage 3 (2 sums)
    reg [15:0] sum_stage4 [1:0];
    wire [15:0] sum_stage4_in [1:0];
    assign sum_stage4_in[0] = sum_stage3[0] + sum_stage3[1];
    assign sum_stage4_in[1] = sum_stage3[2] + sum_stage3[3];

    // Stage 5 register: final sum (1 sum)
    reg [15:0] mul_out_reg;
    wire [15:0] final_sum = sum_stage4[0] + sum_stage4[1];

    // Pipeline enable control:
    // mul_en_in sampled at input stage (stage 1)
    // mul_en_pipe shifts through 5 stages to align with output at stage 5
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // Stage 1: sample input operands when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 3 registers update (pairwise partial products sums)
    // Only update when mul_en_pipe[1] is asserted (after sampling inputs)
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 4; idx = idx + 1)
                sum_stage3[idx] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            for (idx = 0; idx < 4; idx = idx + 1)
                sum_stage3[idx] <= sum_stage3_in[idx];
        end else begin
            for (idx = 0; idx < 4; idx = idx + 1)
                sum_stage3[idx] <= 16'd0;
        end
    end

    // Stage 4 registers update (sum pairs from stage 3)
    // Update when mul_en_pipe[2] is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4[0] <= 16'd0;
            sum_stage4[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage4[0] <= sum_stage4_in[0];
            sum_stage4[1] <= sum_stage4_in[1];
        end else begin
            sum_stage4[0] <= 16'd0;
            sum_stage4[1] <= 16'd0;
        end
    end

    // Stage 5 registers update (final sum)
    // Update when mul_en_pipe[3] is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= final_sum;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable signal from MSB of enable pipeline (stage 5)
    assign mul_en_out = mul_en_pipe[4];

    // Output product valid only when enable output is active
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule