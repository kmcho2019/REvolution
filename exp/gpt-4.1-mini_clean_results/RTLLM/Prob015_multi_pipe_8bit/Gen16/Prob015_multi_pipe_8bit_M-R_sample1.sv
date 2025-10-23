module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signals (3-stage pipeline)
    reg mul_en_stage1, mul_en_stage2, mul_en_stage3;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];

    // First pipeline stage register for partial sums
    reg [15:0] partial_sum_stage;

    // Final output register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Register inputs and enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage1 <= 1'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally based on registered operands
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Stage 2: Register enable and accumulate partial sums into one 16-bit sum register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage2 <= 1'b0;
            partial_sum_stage <= 16'd0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;

            if (mul_en_stage1) begin
                // Sum partial products and register result
                partial_sum_stage <= partial_products[0] + partial_products[1] + partial_products[2] +
                                     partial_products[3] + partial_products[4] + partial_products[5] +
                                     partial_products[6] + partial_products[7];
            end else begin
                partial_sum_stage <= 16'd0;
            end
        end
    end

    // Stage 3: Register enable and final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stage3 <= 1'b0;
            mul_out_reg <= 16'd0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;

            if (mul_en_stage2) begin
                mul_out_reg <= partial_sum_stage;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable signal is the enable at stage 3
    assign mul_en_out = mul_en_stage3;

    // Output product is valid only when mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule