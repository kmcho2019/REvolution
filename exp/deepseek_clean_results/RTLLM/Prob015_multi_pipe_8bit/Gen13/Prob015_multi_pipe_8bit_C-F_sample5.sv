module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control signals
    reg [3:0] en_pipeline;
    wire [3:0] stage_active;
    assign stage_active = {en_pipeline[2:0], mul_en_in};

    // Clock gating for each stage
    wire clk_stage1 = clk & stage_active[0];
    wire clk_stage2 = clk & stage_active[1];
    wire clk_stage3 = clk & stage_active[2];
    wire clk_stage4 = clk & stage_active[3];

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp01_reg, pp23_reg, pp45_reg, pp67_reg;
    reg [15:0] sum_low_reg, sum_high_reg;
    reg [15:0] result_reg;

    // Parameterized partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (mul_en_in & b_reg[i]) ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Input registration
    always @(posedge clk_stage1 or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: First level adder tree
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];

    always @(posedge clk_stage2 or negedge rst_n) begin
        if (!rst_n) begin
            pp01_reg <= 16'b0;
            pp23_reg <= 16'b0;
            pp45_reg <= 16'b0;
            pp67_reg <= 16'b0;
        end else begin
            pp01_reg <= sum01;
            pp23_reg <= sum23;
            pp45_reg <= sum45;
            pp67_reg <= sum67;
        end
    end

    // Stage 3: Second level adder tree
    wire [15:0] sum_low = pp01_reg + pp23_reg;
    wire [15:0] sum_high = pp45_reg + pp67_reg;

    always @(posedge clk_stage3 or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg <= 16'b0;
            sum_high_reg <= 16'b0;
        end else begin
            sum_low_reg <= sum_low;
            sum_high_reg <= sum_high;
        end
    end

    // Stage 4: Final addition and result
    wire [15:0] final_sum = sum_low_reg + sum_high_reg;

    always @(posedge clk_stage4 or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else begin
            result_reg <= final_sum;
        end
    end

    // Enable signal pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 4'b0;
        end else begin
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg : 16'b0;

endmodule