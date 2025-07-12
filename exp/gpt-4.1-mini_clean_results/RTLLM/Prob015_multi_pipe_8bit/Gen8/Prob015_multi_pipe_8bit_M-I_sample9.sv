module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline registers for enable signals (3-stage)
    reg [2:0] mul_en_pipe;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: Each 16-bit partial product for mul_b_reg bit
    wire [15:0] partial_products [7:0];

    // Stage 1: Generate partial products combinationally from registered inputs
    integer i;
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums after first addition stage
    reg [15:0] sum_stage1_0;
    reg [15:0] sum_stage1_1;
    reg [15:0] sum_stage1_2;
    reg [15:0] sum_stage1_3;

    // Pipeline register for final sum before output register stage
    reg [15:0] sum_stage2;

    // Final product register
    reg [15:0] mul_out_reg;

    // Input sampling and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1: Partial sum first level of addition (reduce 8 partial products to 4 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_0 <= 16'd0;
            sum_stage1_1 <= 16'd0;
            sum_stage1_2 <= 16'd0;
            sum_stage1_3 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum_stage1_0 <= partial_products[0] + partial_products[1];
            sum_stage1_1 <= partial_products[2] + partial_products[3];
            sum_stage1_2 <= partial_products[4] + partial_products[5];
            sum_stage1_3 <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage1_0 <= 16'd0;
            sum_stage1_1 <= 16'd0;
            sum_stage1_2 <= 16'd0;
            sum_stage1_3 <= 16'd0;
        end
    end

    // Stage 2: Partial sum second level of addition (reduce 4 sums to 2 sums)
    reg [15:0] sum_stage2_0, sum_stage2_1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= 16'd0;
            sum_stage2_1 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
            sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
        end else begin
            sum_stage2_0 <= 16'd0;
            sum_stage2_1 <= 16'd0;
        end
    end

    // Stage 3: Final sum stage (sum two intermediate sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage2 <= sum_stage2_0 + sum_stage2_1;
        end else begin
            sum_stage2 <= 16'd0;
        end
    end

    // Final output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage2;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable and product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= mul_en_pipe[2];
        end
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule