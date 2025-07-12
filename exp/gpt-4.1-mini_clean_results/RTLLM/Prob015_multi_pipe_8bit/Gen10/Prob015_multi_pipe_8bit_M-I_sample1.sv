module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // 3-stage enable pipeline corresponding to 3 pipeline stages after input registers
    reg [2:0] mul_en_pipe;

    // Input registers: sample inputs when mul_en_in is asserted; hold otherwise
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires - 8 partial products
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1 partial sums: sum groups of three partial products
    reg [15:0] sum_group0_stage1; // sum partial_products[0..2]
    reg [15:0] sum_group1_stage1; // sum partial_products[3..5]

    // Stage 2 partial sum: sum the two stage 1 sums
    reg [15:0] sum_stage2;

    // Stage 3 partial sum: sum partial_products[6..7]
    reg [15:0] sum_group2_stage3;

    // Final product register: sum of stage 2 sum and stage 3 sum
    reg [15:0] mul_out_reg;

    // Enable pipeline shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // Input registers update on mul_en_in active; hold otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1 partial sums registers update on mul_en_pipe[0]; hold otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_group0_stage1 <= 16'b0;
            sum_group1_stage1 <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_group0_stage1 <= partial_products[0] + partial_products[1] + partial_products[2];
            sum_group1_stage1 <= partial_products[3] + partial_products[4] + partial_products[5];
        end
    end

    // Stage 2 sum of stage 1 sums registers update on mul_en_pipe[1]; hold otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_stage2 <= 16'b0;
        else if (mul_en_pipe[1])
            sum_stage2 <= sum_group0_stage1 + sum_group1_stage1;
    end

    // Stage 3 sum partial_products[6..7] registers update on mul_en_pipe[1]; hold otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_group2_stage3 <= 16'b0;
        else if (mul_en_pipe[1])
            sum_group2_stage3 <= partial_products[6] + partial_products[7];
    end

    // Final product register update on mul_en_pipe[2]; hold otherwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_stage2 + sum_group2_stage3;
    end

    // Output enable from last bit of enable pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product valid only when mul_en_out is high; zero otherwise
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule