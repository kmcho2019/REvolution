module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 0: Input registers and enable pipeline
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [3:0] mul_en_pipe;

    // Stage 1: Partial products generation (8 partial products)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 registers: Register partial products in pairs to prepare for additions
    reg [15:0] pp_stage1 [7:0];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_pipe <= 4'b0;
            for (idx = 0; idx < 8; idx = idx + 1) begin
                pp_stage1[idx] <= 16'd0;
            end
        end else begin
            // Shift enable pipeline to track valid data through stages
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            for (idx = 0; idx < 8; idx = idx + 1) begin
                pp_stage1[idx] <= partial_products[idx];
            end
        end
    end

    // Stage 2: Add pairs of partial products -> 4 sums
    reg [15:0] sum_stage2 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 4; idx = idx + 1) sum_stage2[idx] <= 16'd0;
        end else begin
            sum_stage2[0] <= pp_stage1[0] + pp_stage1[1];
            sum_stage2[1] <= pp_stage1[2] + pp_stage1[3];
            sum_stage2[2] <= pp_stage1[4] + pp_stage1[5];
            sum_stage2[3] <= pp_stage1[6] + pp_stage1[7];
        end
    end

    // Stage 3: Add pairs of sums from stage 2 -> 2 sums
    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end
    end

    // Stage 4: Final sum of two sums from stage 3
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable register (stage 4)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // Output assignment with enable gating
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule