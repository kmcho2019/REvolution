module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output     [15:0]  mul_out
);

    // Pipeline registers for enable signal (4 stages)
    reg [3:0] mul_en_pipe;
    // Input registers sampled when mul_en_in asserted
    reg [7:0] mul_a_reg, mul_b_reg;

    // Stage 1: Sample inputs and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Partial products (stage 1): wires, combinational
    wire [15:0] pp0 = mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
    wire [15:0] pp1 = mul_b_reg[1] ? ({7'b0, mul_a_reg, 1'b0}) : 16'b0;
    wire [15:0] pp2 = mul_b_reg[2] ? ({6'b0, mul_a_reg, 2'b0}) : 16'b0;
    wire [15:0] pp3 = mul_b_reg[3] ? ({5'b0, mul_a_reg, 3'b0}) : 16'b0;
    wire [15:0] pp4 = mul_b_reg[4] ? ({4'b0, mul_a_reg, 4'b0}) : 16'b0;
    wire [15:0] pp5 = mul_b_reg[5] ? ({3'b0, mul_a_reg, 5'b0}) : 16'b0;
    wire [15:0] pp6 = mul_b_reg[6] ? ({2'b0, mul_a_reg, 6'b0}) : 16'b0;
    wire [15:0] pp7 = mul_b_reg[7] ? ({1'b0, mul_a_reg, 7'b0}) : 16'b0;

    // Stage 2: Pairwise addition of partial products registers
    reg [15:0] sum_stage2_0, sum_stage2_1, sum_stage2_2, sum_stage2_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= 16'b0;
            sum_stage2_1 <= 16'b0;
            sum_stage2_2 <= 16'b0;
            sum_stage2_3 <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_stage2_0 <= pp0 + pp1;
            sum_stage2_1 <= pp2 + pp3;
            sum_stage2_2 <= pp4 + pp5;
            sum_stage2_3 <= pp6 + pp7;
        end else begin
            sum_stage2_0 <= 16'b0;
            sum_stage2_1 <= 16'b0;
            sum_stage2_2 <= 16'b0;
            sum_stage2_3 <= 16'b0;
        end
    end

    // Stage 3: Add pairs from stage 2
    reg [15:0] sum_stage3_0, sum_stage3_1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_0 <= 16'b0;
            sum_stage3_1 <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3_0 <= sum_stage2_0 + sum_stage2_1;
            sum_stage3_1 <= sum_stage2_2 + sum_stage2_3;
        end else begin
            sum_stage3_0 <= 16'b0;
            sum_stage3_1 <= 16'b0;
        end
    end

    // Stage 4: Final sum stage
    reg [15:0] sum_final;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_final <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_final <= sum_stage3_0 + sum_stage3_1;
        end else begin
            sum_final <= 16'b0;
        end
    end

    // Output register stage 5
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_final;
        end else begin
            mul_out_reg <= 16'b0;
        end
    end

    // Output enable register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            mul_en_out <= 1'b0;
        else 
            mul_en_out <= mul_en_pipe[3];
    end

    // Output assignment: combinational
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule