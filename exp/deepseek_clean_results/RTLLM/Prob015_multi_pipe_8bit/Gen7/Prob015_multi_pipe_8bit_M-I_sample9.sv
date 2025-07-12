module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (with clock gating)
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    wire stage1_clken = mul_en_in | !rst_n;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp0, pp1, pp2, pp3;
    reg [15:0] pp4, pp5, pp6, pp7;
    reg stage2_en;
    wire stage2_clken = stage1_en | !rst_n;
    
    // Pipeline stage 3 registers (intermediate sums)
    reg [15:0] sum_low, sum_high;
    reg stage3_en;
    wire stage3_clken = stage2_en | !rst_n;
    
    // Pipeline stage 4 registers (final result)
    reg [15:0] stage4_result;
    reg stage4_en;
    wire stage4_clken = stage3_en | !rst_n;

    // Carry-save intermediate sums
    wire [15:0] cs_sum1, cs_sum2, cs_carry1, cs_carry2;
    
    // Clock-gated always blocks
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
        end else if (stage1_clken) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7} <= {8{16'b0}};
            stage2_en <= 1'b0;
        end else if (stage2_clken) begin
            // Operand-isolated partial products
            pp0 <= stage1_en ? {8'b0, stage1_b[0] ? stage1_a : 8'b0} : 16'b0;
            pp1 <= stage1_en ? {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0} : 16'b0;
            pp2 <= stage1_en ? {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0} : 16'b0;
            pp3 <= stage1_en ? {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0} : 16'b0;
            pp4 <= stage1_en ? {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0} : 16'b0;
            pp5 <= stage1_en ? {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0} : 16'b0;
            pp6 <= stage1_en ? {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0} : 16'b0;
            pp7 <= stage1_en ? {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0} : 16'b0;
            stage2_en <= stage1_en;
        end
    end

    // Carry-save addition for first stage
    assign cs_sum1 = pp0 + pp1;
    assign cs_carry1 = pp2 + pp3;
    assign cs_sum2 = pp4 + pp5;
    assign cs_carry2 = pp6 + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low <= 16'b0;
            sum_high <= 16'b0;
            stage3_en <= 1'b0;
        end else if (stage3_clken) begin
            sum_low <= cs_sum1 + cs_carry1;  // Shared adder
            sum_high <= cs_sum2 + cs_carry2; // Shared adder
            stage3_en <= stage2_en;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage4_result <= 16'b0;
            stage4_en <= 1'b0;
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else if (stage4_clken) begin
            stage4_result <= sum_low + sum_high;
            stage4_en <= stage3_en;
            mul_out <= stage3_en ? (sum_low + sum_high) : 16'b0;
            mul_en_out <= stage3_en;
        end
    end

endmodule