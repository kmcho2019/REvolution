module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Enable pipeline (4 stages), shift register for enable signals
    reg [3:0] mul_en_pipe;

    // Input operand registers, updated only when mul_en_in is high
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: 8 partial products of 16-bit width
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 summation: sum partial products in pairs
    reg [15:0] sum_0_1, sum_2_3, sum_4_5, sum_6_7;
    reg        mul_en_stage1;

    // Stage 2 summation: sum pairs from stage 1
    reg [15:0] sum_01_23, sum_45_67;
    reg        mul_en_stage2;

    // Stage 3 summation: final sum
    reg [15:0] mul_out_reg;
    reg        mul_en_stage3;

    // Input registers and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1 summation registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1    <= 16'd0;
            sum_2_3    <= 16'd0;
            sum_4_5    <= 16'd0;
            sum_6_7    <= 16'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            if (mul_en_pipe[0]) begin
                sum_0_1 <= partial_products[0] + partial_products[1];
                sum_2_3 <= partial_products[2] + partial_products[3];
                sum_4_5 <= partial_products[4] + partial_products[5];
                sum_6_7 <= partial_products[6] + partial_products[7];
            end else begin
                sum_0_1 <= 16'd0;
                sum_2_3 <= 16'd0;
                sum_4_5 <= 16'd0;
                sum_6_7 <= 16'd0;
            end
            mul_en_stage1 <= mul_en_pipe[0];
        end
    end

    // Stage 2 summation registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_23 <= 16'd0;
            sum_45_67 <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            if (mul_en_stage1) begin
                sum_01_23 <= sum_0_1 + sum_2_3;
                sum_45_67 <= sum_4_5 + sum_6_7;
            end else begin
                sum_01_23 <= 16'd0;
                sum_45_67 <= 16'd0;
            end
            mul_en_stage2 <= mul_en_stage1;
        end
    end

    // Stage 3 summation register (final product)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            if (mul_en_stage2) begin
                mul_out_reg <= sum_01_23 + sum_45_67;
            end else begin
                mul_out_reg <= 16'd0;
            end
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Output enable assigned from MSB of enable pipeline (stage 4)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= mul_en_pipe[3];
        end
    end

    // Output product assigned when enabled, else zero
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'd0;
        end else begin
            mul_out <= mul_en_out ? mul_out_reg : 16'd0;
        end
    end

endmodule