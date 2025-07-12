module multi_pipe_8bit (
    input            clk,
    input            rst_n,
    input            mul_en_in,
    input      [7:0] mul_a,
    input      [7:0] mul_b,
    output reg       mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers for enable signals (4-stage)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 partial sum registers (for bits [1:0])
    reg [15:0] sum_stage2;

    // Stage 3 partial sum registers (for bits [3:2] added to sum_stage2)
    reg [15:0] sum_stage3;

    // Stage 4 partial sum registers (for bits [7:4] added to sum_stage3)
    reg [15:0] sum_stage4;

    // ======= Stage 1 =======
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            // Shift enable pipeline and sample new enable
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // ======= Stage 2 =======
    // Generate partial products for multiplier bits [1:0]
    wire [15:0] pp0_s2 = mul_b_reg[0] ? {8'd0, mul_a_reg}        : 16'd0;  // bit 0 partial product (mul_a << 0)
    wire [15:0] pp1_s2 = mul_b_reg[1] ? {7'd0, mul_a_reg, 1'b0} : 16'd0;  // bit 1 partial product (mul_a << 1)
    wire [15:0] sum_stage2_next = pp0_s2 + pp1_s2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2 <= sum_stage2_next;
        end else begin
            sum_stage2 <= 16'd0;
        end
    end

    // ======= Stage 3 =======
    // Generate partial products for bits [3:2]
    wire [15:0] pp2_s3 = mul_b_reg[2] ? {6'd0, mul_a_reg, 2'b00} : 16'd0; // mul_a << 2
    wire [15:0] pp3_s3 = mul_b_reg[3] ? {5'd0, mul_a_reg, 3'b000}: 16'd0; // mul_a << 3
    wire [15:0] sum_stage3_next = sum_stage2 + pp2_s3 + pp3_s3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage3 <= sum_stage3_next;
        end else begin
            sum_stage3 <= 16'd0;
        end
    end

    // ======= Stage 4 =======
    // Generate partial products for bits [7:4]
    wire [15:0] pp4_s4 = mul_b_reg[4] ? {3'd0, mul_a_reg, 4'b0000} : 16'd0; // mul_a << 4
    wire [15:0] pp5_s4 = mul_b_reg[5] ? {2'd0, mul_a_reg, 5'b00000}: 16'd0; // mul_a << 5
    wire [15:0] pp6_s4 = mul_b_reg[6] ? {1'd0, mul_a_reg, 6'b000000}: 16'd0; // mul_a << 6
    wire [15:0] pp7_s4 = mul_b_reg[7] ? {mul_a_reg, 7'b0000000}       : 16'd0; // mul_a << 7

    wire [15:0] sum_stage4_next = sum_stage3 + pp4_s4 + pp5_s4 + pp6_s4 + pp7_s4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4 <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            sum_stage4 <= sum_stage4_next;
        end else begin
            sum_stage4 <= 16'd0;
        end
    end

    // Output enable and product signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_pipe[3];
            mul_out <= mul_en_pipe[3] ? sum_stage4 : 16'd0;
        end
    end

endmodule