module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline stages count:
    // Stage 0: Input registers (mul_a_reg, mul_b_reg)
    // Stage 1: Partial product generation and register partial products (pp_reg)
    // Stage 2: Pairwise sum of partial products (sum_stage2)
    // Stage 3: Pairwise sum of stage2 sums (sum_stage3)
    // Stage 4: Final sum and output register (mul_out_reg)

    // 1) Input registers and enable pipeline (stage 0)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg [4:0] mul_en_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_pipe <= 5'b0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // 2) Partial product generation (stage 1) and register partial products
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    reg [15:0] pp_reg [7:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 8; idx = idx + 1) begin
                pp_reg[idx] <= 16'd0;
            end
        end else if (mul_en_pipe[0]) begin
            for (idx = 0; idx < 8; idx = idx + 1) begin
                pp_reg[idx] <= partial_products[idx];
            end
        end
    end

    // 3) Stage 2: Sum partial products pairwise -> 4 sums
    reg [15:0] sum_stage2 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 4; idx = idx + 1) begin
                sum_stage2[idx] <= 16'd0;
            end
        end else if (mul_en_pipe[1]) begin
            sum_stage2[0] <= pp_reg[0] + pp_reg[1];
            sum_stage2[1] <= pp_reg[2] + pp_reg[3];
            sum_stage2[2] <= pp_reg[4] + pp_reg[5];
            sum_stage2[3] <= pp_reg[6] + pp_reg[7];
        end
    end

    // 4) Stage 3: Sum the 4 sums pairwise -> 2 sums
    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end
    end

    // 5) Stage 4: Final sum of two sums and register output
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end
    end

    // Output enable pipeline synchronization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= mul_en_pipe[4];
        end
    end

    // Output product assignment gated by enable
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule