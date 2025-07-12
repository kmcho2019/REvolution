module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline: 4-stage to track input and all pipeline stages
    // Stage 0: input enable sampled
    // Stage 1: after partial product generation
    // Stage 2: after first level addition
    // Stage 3: after second level addition (output valid)
    reg [3:0] mul_en_pipe;

    // Stage 0: Register inputs when mul_en_in is active
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Generate partial products (16-bit each)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: First level adder pipeline registers
    // Add partial products pairwise to reduce number of operands from 8 to 4
    reg [15:0] sum_level1 [3:0];
    wire [15:0] sum_level1_next [3:0];
    // Combinational addition for level 1
    assign sum_level1_next[0] = partial_products[0] + partial_products[1];
    assign sum_level1_next[1] = partial_products[2] + partial_products[3];
    assign sum_level1_next[2] = partial_products[4] + partial_products[5];
    assign sum_level1_next[3] = partial_products[6] + partial_products[7];

    // Stage 3: Second level adder pipeline registers
    // Add results from level 1 pairwise to reduce from 4 to 2
    reg [15:0] sum_level2 [1:0];
    wire [15:0] sum_level2_next [1:0];
    assign sum_level2_next[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2_next[1] = sum_level1[2] + sum_level1[3];

    // Stage 4: Final sum register: sum of the two sums from level 2
    reg [15:0] mul_out_reg;
    wire [15:0] final_sum;
    assign final_sum = sum_level2[0] + sum_level2[1];

    integer idx;

    // Pipeline registers and controls
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;

            for (idx = 0; idx < 4; idx = idx + 1) begin
                sum_level1[idx] <= 16'b0;
            end

            for (idx = 0; idx < 2; idx = idx + 1) begin
                sum_level2[idx] <= 16'b0;
            end

            mul_out_reg <= 16'b0;
        end else begin
            // Shift enable pipeline left, capturing input enable at LSB
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

            // Stage 0 input registers updated when mul_en_in is active
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 1 sum_level1 registers updated when enable stage 1 is active
            // mul_en_pipe[0] corresponds to input sampled stage, so sum_level1 updated next cycle
            if (mul_en_pipe[0]) begin
                for (idx = 0; idx < 4; idx = idx + 1) begin
                    sum_level1[idx] <= sum_level1_next[idx];
                end
            end else begin
                for (idx = 0; idx < 4; idx = idx + 1) begin
                    sum_level1[idx] <= 16'b0;
                end
            end

            // Stage 2 sum_level2 registers updated when enable stage 2 is active
            if (mul_en_pipe[1]) begin
                for (idx = 0; idx < 2; idx = idx + 1) begin
                    sum_level2[idx] <= sum_level2_next[idx];
                end
            end else begin
                for (idx = 0; idx < 2; idx = idx + 1) begin
                    sum_level2[idx] <= 16'b0;
                end
            end

            // Stage 3 output register updated when enable stage 3 is active
            if (mul_en_pipe[2]) begin
                mul_out_reg <= final_sum;
            end else begin
                mul_out_reg <= 16'b0;
            end
        end
    end

    // Output enable from the MSB of the pipeline (stage 3)
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when mul_en_out is active, otherwise zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule