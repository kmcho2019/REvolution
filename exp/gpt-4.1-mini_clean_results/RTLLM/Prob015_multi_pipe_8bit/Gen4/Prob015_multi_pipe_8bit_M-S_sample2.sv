module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline register (4 stages total: input + 3 pipeline adds)
    reg [3:0] en_pipe;

    // Input operand registers (load only when mul_en_in is asserted)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires generated combinationally from registered operands
    wire [15:0] pp [7:0];
    assign pp[0] = mul_b_reg[0] ? (mul_a_reg << 0) : 16'b0;
    assign pp[1] = mul_b_reg[1] ? (mul_a_reg << 1) : 16'b0;
    assign pp[2] = mul_b_reg[2] ? (mul_a_reg << 2) : 16'b0;
    assign pp[3] = mul_b_reg[3] ? (mul_a_reg << 3) : 16'b0;
    assign pp[4] = mul_b_reg[4] ? (mul_a_reg << 4) : 16'b0;
    assign pp[5] = mul_b_reg[5] ? (mul_a_reg << 5) : 16'b0;
    assign pp[6] = mul_b_reg[6] ? (mul_a_reg << 6) : 16'b0;
    assign pp[7] = mul_b_reg[7] ? (mul_a_reg << 7) : 16'b0;

    // Pipeline registers for sum stages
    reg [15:0] sum_stage1_0, sum_stage1_1, sum_stage1_2, sum_stage1_3;
    reg [15:0] sum_stage2_0, sum_stage2_1;
    reg [15:0] mul_out_reg;

    // Enable pipeline shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 4'b0;
        else
            en_pipe <= {en_pipe[2:0], mul_en_in};
    end

    // Capture inputs when mul_en_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1: Add pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_0 <= 16'b0;
            sum_stage1_1 <= 16'b0;
            sum_stage1_2 <= 16'b0;
            sum_stage1_3 <= 16'b0;
        end else begin
            // Only update sums when corresponding enable is high
            if (en_pipe[0]) begin
                sum_stage1_0 <= pp[0] + pp[1];
                sum_stage1_1 <= pp[2] + pp[3];
                sum_stage1_2 <= pp[4] + pp[5];
                sum_stage1_3 <= pp[6] + pp[7];
            end
        end
    end

    // Stage 2: Add results from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= 16'b0;
            sum_stage2_1 <= 16'b0;
        end else begin
            if (en_pipe[1]) begin
                sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
                sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
            end
        end
    end

    // Stage 3: Final addition to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (en_pipe[2])
            mul_out_reg <= sum_stage2_0 + sum_stage2_1;
    end

    // Output enable is last stage of enable pipeline
    assign mul_en_out = en_pipe[3];

    // Output product if enabled, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule