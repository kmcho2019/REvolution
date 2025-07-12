module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 0: Register inputs and enable pipeline (4-stage pipeline, so 4-bit enable shift reg)
    reg [7:0] mul_a_reg_s0;
    reg [7:0] mul_b_reg_s0;
    reg [3:0] mul_en_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg_s0 <= 8'd0;
            mul_b_reg_s0 <= 8'd0;
            mul_en_pipe <= 4'b0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg_s0 <= mul_a;
                mul_b_reg_s0 <= mul_b;
            end
        end
    end

    // Stage 1: Generate partial products (each 16-bit aligned)
    reg [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 16'd0;
            pp1 <= 16'd0;
            pp2 <= 16'd0;
            pp3 <= 16'd0;
            pp4 <= 16'd0;
            pp5 <= 16'd0;
            pp6 <= 16'd0;
            pp7 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            // Generate partial products by ANDing and shifting multiplicand based on multiplier bits
            pp0 <= mul_b_reg_s0[0] ? (mul_a_reg_s0 << 0) : 16'd0;
            pp1 <= mul_b_reg_s0[1] ? (mul_a_reg_s0 << 1) : 16'd0;
            pp2 <= mul_b_reg_s0[2] ? (mul_a_reg_s0 << 2) : 16'd0;
            pp3 <= mul_b_reg_s0[3] ? (mul_a_reg_s0 << 3) : 16'd0;
            pp4 <= mul_b_reg_s0[4] ? (mul_a_reg_s0 << 4) : 16'd0;
            pp5 <= mul_b_reg_s0[5] ? (mul_a_reg_s0 << 5) : 16'd0;
            pp6 <= mul_b_reg_s0[6] ? (mul_a_reg_s0 << 6) : 16'd0;
            pp7 <= mul_b_reg_s0[7] ? (mul_a_reg_s0 << 7) : 16'd0;
        end
    end

    // Stage 2: First summation layer (sum pairs), register results
    reg [15:0] sum0_1, sum2_3, sum4_5, sum6_7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_1 <= 16'd0;
            sum2_3 <= 16'd0;
            sum4_5 <= 16'd0;
            sum6_7 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum0_1 <= pp0 + pp1;
            sum2_3 <= pp2 + pp3;
            sum4_5 <= pp4 + pp5;
            sum6_7 <= pp6 + pp7;
        end
    end

    // Stage 3: Final summation and output register
    reg [15:0] final_sum_0_3, final_sum_4_7;
    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_0_3 <= 16'd0;
            final_sum_4_7 <= 16'd0;
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            final_sum_0_3 <= sum0_1 + sum2_3;
            final_sum_4_7 <= sum4_5 + sum6_7;
            mul_out_reg <= 16'd0; // Clear mul_out_reg early, will update next cycle
        end else if (mul_en_pipe[3]) begin
            // Final addition of two big partial sums
            mul_out_reg <= final_sum_0_3 + final_sum_4_7;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable is the MSB of the 4-bit pipeline
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