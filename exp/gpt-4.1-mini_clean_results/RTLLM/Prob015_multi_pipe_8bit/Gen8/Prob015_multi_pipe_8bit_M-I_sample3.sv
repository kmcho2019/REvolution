module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Input registers with enable gating
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Enable pipeline for tracking valid data through 4 pipeline stages
    reg [3:0] mul_en_pipe;

    // Partial products wires (combinational, generated each cycle from registered inputs)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 registers for partial products with clock gating
    reg [15:0] pp_stage1 [7:0];

    // Stage 2 registers for sum of pairs of partial products
    reg [15:0] sum_stage2 [3:0];

    // Stage 3 registers for sum of pairs of sums from stage 2
    reg [15:0] sum_stage3 [1:0];

    // Stage 4 register for final product
    reg [15:0] mul_out_reg;

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_pipe <= 4'b0;
            for (idx = 0; idx < 8; idx = idx + 1) begin
                pp_stage1[idx] <= 16'd0;
            end
            for (idx = 0; idx < 4; idx = idx + 1) begin
                sum_stage2[idx] <= 16'd0;
            end
            for (idx = 0; idx < 2; idx = idx + 1) begin
                sum_stage3[idx] <= 16'd0;
            end
            mul_out_reg <= 16'd0;
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            // Pipeline the enable signal to track valid multiplication data through stages
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

            // Input registers update only when mul_en_in is high to reduce switching
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 1 registers update only when previous stage enable is asserted (mul_en_in)
            if (mul_en_in) begin
                for (idx = 0; idx < 8; idx = idx + 1) begin
                    pp_stage1[idx] <= partial_products[idx];
                end
            end

            // Stage 2 registers update only when previous stage enable pipe[1] is asserted
            if (mul_en_pipe[1]) begin
                sum_stage2[0] <= pp_stage1[0] + pp_stage1[1];
                sum_stage2[1] <= pp_stage1[2] + pp_stage1[3];
                sum_stage2[2] <= pp_stage1[4] + pp_stage1[5];
                sum_stage2[3] <= pp_stage1[6] + pp_stage1[7];
            end

            // Stage 3 registers update only when previous stage enable pipe[2] is asserted
            if (mul_en_pipe[2]) begin
                sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
                sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
            end

            // Stage 4: final sum and output register update only when enable pipe[3] is asserted
            if (mul_en_pipe[3]) begin
                mul_out_reg <= sum_stage3[0] + sum_stage3[1];
            end else begin
                // Optional: clear output register when no valid data
                mul_out_reg <= 16'd0;
            end

            // Output enable registered at final stage
            mul_en_out <= mul_en_pipe[3];

            // Output product assignment synchronous to clock, driven by mul_en_out
            if (mul_en_pipe[3]) begin
                mul_out <= mul_out_reg;
            end else begin
                mul_out <= 16'd0;
            end
        end
    end

endmodule