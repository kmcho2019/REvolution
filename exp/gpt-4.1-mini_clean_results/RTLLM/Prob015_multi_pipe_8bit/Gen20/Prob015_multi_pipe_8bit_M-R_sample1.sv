module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: inputs and enable
    reg [7:0] mul_a_reg, mul_b_reg;
    reg       mul_en_stage1;

    // Stage 2 registers: partial products and enable
    reg [15:0] pp [7:0];  // partial products registers
    reg        mul_en_stage2;

    // Stage 3 registers: sum intermediates and enable
    reg [15:0] sum_stage3_0, sum_stage3_1, sum_stage3_2, sum_stage3_3;
    reg        mul_en_stage3;

    // Stage 4 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage4;

    integer i;

    // Stage 1: Register inputs and enable
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

    // Stage 2: Generate and register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            if (mul_en_stage1) begin
                for (i = 0; i < 8; i = i + 1)
                    pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
            end else begin
                for (i = 0; i < 8; i = i + 1)
                    pp[i] <= 16'd0;
            end
            mul_en_stage2 <= mul_en_stage1;
        end
    end

    // Stage 3: Sum partial products in pairs to reduce adder tree depth
    // sum_stage3_x hold sums of pairs: (pp[0]+pp[1]), (pp[2]+pp[3]), etc.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            sum_stage3_2 <= 16'd0;
            sum_stage3_3 <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            sum_stage3_0 <= pp[0] + pp[1];
            sum_stage3_1 <= pp[2] + pp[3];
            sum_stage3_2 <= pp[4] + pp[5];
            sum_stage3_3 <= pp[6] + pp[7];
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Stage 4: Sum pairs of sums and register final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            // sum pairs of sums
            mul_out_reg <= (sum_stage3_0 + sum_stage3_1) + (sum_stage3_2 + sum_stage3_3);
            mul_en_stage4 <= mul_en_stage3;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_stage4;
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule