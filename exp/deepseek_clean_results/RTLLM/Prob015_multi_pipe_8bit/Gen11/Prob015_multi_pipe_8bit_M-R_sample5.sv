module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage enables
    wire stage1_en = mul_en_in;
    wire stage2_en;
    wire stage3_en;
    wire stage4_en;

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp01_reg, pp23_reg, pp45_reg, pp67_reg;
    reg [15:0] sum_low_reg, sum_high_reg;
    reg [15:0] result_reg;
    reg en_reg1, en_reg2, en_reg3, en_reg4;

    // Clock gating per stage
    wire clk_stage1 = clk & (stage1_en | en_reg1);
    wire clk_stage2 = clk & (stage2_en | en_reg2);
    wire clk_stage3 = clk & (stage3_en | en_reg3);
    wire clk_stage4 = clk & stage4_en;

    // Partial products (generated in one cycle)
    wire [15:0] pp0 = b_reg[0] ? {8'b0, a_reg} : 16'b0;
    wire [15:0] pp1 = b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0;
    wire [15:0] pp2 = b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0;
    wire [15:0] pp3 = b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0;
    wire [15:0] pp4 = b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0;
    wire [15:0] pp5 = b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0;
    wire [15:0] pp6 = b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0;
    wire [15:0] pp7 = b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0;

    // Adder tree
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    wire [15:0] final_sum = sum_low + sum_high;

    // Stage 1: Input registration
    always @(posedge clk_stage1 or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
        end else begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
        end
    end

    assign stage2_en = en_reg1;

    // Stage 2: Partial sums
    always @(posedge clk_stage2 or negedge rst_n) begin
        if (!rst_n) begin
            pp01_reg <= 16'b0;
            pp23_reg <= 16'b0;
            pp45_reg <= 16'b0;
            pp67_reg <= 16'b0;
            en_reg2 <= 1'b0;
        end else begin
            pp01_reg <= sum01;
            pp23_reg <= sum23;
            pp45_reg <= sum45;
            pp67_reg <= sum67;
            en_reg2 <= en_reg1;
        end
    end

    assign stage3_en = en_reg2;

    // Stage 3: Intermediate sums
    always @(posedge clk_stage3 or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg <= 16'b0;
            sum_high_reg <= 16'b0;
            en_reg3 <= 1'b0;
        end else begin
            sum_low_reg <= sum_low;
            sum_high_reg <= sum_high;
            en_reg3 <= en_reg2;
        end
    end

    assign stage4_en = en_reg3;

    // Stage 4: Final result
    always @(posedge clk_stage4 or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
            en_reg4 <= 1'b0;
        end else begin
            result_reg <= final_sum;
            en_reg4 <= en_reg3;
        end
    end

    // Output assignments
    assign mul_en_out = en_reg4;
    assign mul_out = en_reg4 ? result_reg : 16'b0;

endmodule