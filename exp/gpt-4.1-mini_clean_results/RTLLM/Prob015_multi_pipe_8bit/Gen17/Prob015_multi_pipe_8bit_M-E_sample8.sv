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
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_stage1;

    // Stage 2 registers: partial products and enable
    reg [15:0] partial_products [7:0];
    reg        mul_en_stage2;

    // Stage 3 registers: sum partial products in two halves and enable
    reg [15:0] sum_low;   // sum of partial_products[0] to partial_products[3]
    reg [15:0] sum_high;  // sum of partial_products[4] to partial_products[7]
    reg        mul_en_stage3;

    // Stage 4 registers: final sum and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage4;

    integer i;

    // Stage 1: latch inputs and input enable
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

    // Stage 2: generate and register partial products and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1) partial_products[i] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;
            if (mul_en_stage1) begin
                // Generate partial products
                partial_products[0] <= mul_b_reg[0] ? {8'd0, mul_a_reg}             : 16'd0;
                partial_products[1] <= mul_b_reg[1] ? ({8'd0, mul_a_reg} << 1)     : 16'd0;
                partial_products[2] <= mul_b_reg[2] ? ({8'd0, mul_a_reg} << 2)     : 16'd0;
                partial_products[3] <= mul_b_reg[3] ? ({8'd0, mul_a_reg} << 3)     : 16'd0;
                partial_products[4] <= mul_b_reg[4] ? ({8'd0, mul_a_reg} << 4)     : 16'd0;
                partial_products[5] <= mul_b_reg[5] ? ({8'd0, mul_a_reg} << 5)     : 16'd0;
                partial_products[6] <= mul_b_reg[6] ? ({8'd0, mul_a_reg} << 6)     : 16'd0;
                partial_products[7] <= mul_b_reg[7] ? ({8'd0, mul_a_reg} << 7)     : 16'd0;
            end else begin
                for (i=0; i<8; i=i+1) partial_products[i] <= 16'd0;
            end
        end
    end

    // Stage 3: first adder stage - sum halves of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low <= 16'd0;
            sum_high <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;
            if (mul_en_stage2) begin
                sum_low  <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
                sum_high <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
            end else begin
                sum_low  <= 16'd0;
                sum_high <= 16'd0;
            end
        end
    end

    // Stage 4: final adder stage - sum two halves and register final product and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            mul_out_reg <= sum_low + sum_high;
            mul_en_stage4 <= mul_en_stage3;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_stage4;
            mul_out <= mul_en_stage4 ? mul_out_reg : 16'd0;
        end
    end

endmodule