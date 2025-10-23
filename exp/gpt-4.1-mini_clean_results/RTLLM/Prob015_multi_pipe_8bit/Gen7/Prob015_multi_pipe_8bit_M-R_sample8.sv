module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg [15:0]   mul_out
);

    // Pipeline enable shift register (4 stages to track data flow)
    reg [3:0] en_pipe;

    // Input registers
    reg [7:0] mul_a_reg, mul_b_reg;

    // Partial products wires
    wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Stage 1: partial sums registers
    reg [15:0] sum_stage1_0, sum_stage1_1, sum_stage1_2, sum_stage1_3;

    // Stage 2: partial sums registers
    reg [15:0] sum_stage2_0, sum_stage2_1;

    // Stage 3: final product register
    reg [15:0] mul_out_reg;

    // Sample inputs and enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            en_pipe   <= 4'b0000;
        end else begin
            en_pipe <= {en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    assign pp0 = mul_b_reg[0] ? {8'd0, mul_a_reg} : 16'd0;
    assign pp1 = mul_b_reg[1] ? ({8'd0, mul_a_reg} << 1) : 16'd0;
    assign pp2 = mul_b_reg[2] ? ({8'd0, mul_a_reg} << 2) : 16'd0;
    assign pp3 = mul_b_reg[3] ? ({8'd0, mul_a_reg} << 3) : 16'd0;
    assign pp4 = mul_b_reg[4] ? ({8'd0, mul_a_reg} << 4) : 16'd0;
    assign pp5 = mul_b_reg[5] ? ({8'd0, mul_a_reg} << 5) : 16'd0;
    assign pp6 = mul_b_reg[6] ? ({8'd0, mul_a_reg} << 6) : 16'd0;
    assign pp7 = mul_b_reg[7] ? ({8'd0, mul_a_reg} << 7) : 16'd0;

    // Stage 1: accumulate partial products into 4 groups of 2 partial products each
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_0 <= 16'd0;
            sum_stage1_1 <= 16'd0;
            sum_stage1_2 <= 16'd0;
            sum_stage1_3 <= 16'd0;
        end else begin
            if (en_pipe[0]) begin
                sum_stage1_0 <= pp0 + pp1;
                sum_stage1_1 <= pp2 + pp3;
                sum_stage1_2 <= pp4 + pp5;
                sum_stage1_3 <= pp6 + pp7;
            end else begin
                sum_stage1_0 <= 16'd0;
                sum_stage1_1 <= 16'd0;
                sum_stage1_2 <= 16'd0;
                sum_stage1_3 <= 16'd0;
            end
        end
    end

    // Stage 2: sum pairs of stage1 results into 2 sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= 16'd0;
            sum_stage2_1 <= 16'd0;
        end else begin
            if (en_pipe[1]) begin
                sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
                sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
            end else begin
                sum_stage2_0 <= 16'd0;
                sum_stage2_1 <= 16'd0;
            end
        end
    end

    // Stage 3: sum final two partial sums into output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_out  <= 1'b0;
            mul_out     <= 16'd0;
        end else begin
            if (en_pipe[2]) begin
                mul_out_reg <= sum_stage2_0 + sum_stage2_1;
            end else begin
                mul_out_reg <= 16'd0;
            end

            mul_en_out <= en_pipe[3];
            mul_out    <= en_pipe[3] ? mul_out_reg : 16'd0;
        end
    end

endmodule