module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1 registers: inputs and enable
    reg [7:0] mul_a_reg, mul_b_reg;
    reg       mul_en_stage1;

    // Stage 2 registers: partial sums and enable
    reg [15:0] partial_sum_low, partial_sum_high;
    reg        mul_en_stage2;

    // Stage 3 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage3;

    // Stage 1: latch inputs and enable when mul_en_in is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products for lower 4 bits of mul_b
    wire [15:0] pp0 = (mul_b_reg[0] ? (mul_a_reg << 0) : 16'd0);
    wire [15:0] pp1 = (mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0);
    wire [15:0] pp2 = (mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0);
    wire [15:0] pp3 = (mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0);

    // Generate partial products for upper 4 bits of mul_b
    wire [15:0] pp4 = (mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0);
    wire [15:0] pp5 = (mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0);
    wire [15:0] pp6 = (mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0);
    wire [15:0] pp7 = (mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0);

    // Stage 2: sum partial products in two halves and register with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum_low  <= 16'd0;
            partial_sum_high <= 16'd0;
            mul_en_stage2    <= 1'b0;
        end else begin
            partial_sum_low  <= pp0 + pp1 + pp2 + pp3;
            partial_sum_high <= pp4 + pp5 + pp6 + pp7;
            mul_en_stage2    <= mul_en_stage1;
        end
    end

    // Stage 3: sum the two halves to get final product and register with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg   <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_out_reg   <= partial_sum_low + partial_sum_high;
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_stage3;
            mul_out    <= mul_en_stage3 ? mul_out_reg : 16'd0;
        end
    end

endmodule