module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Input enable pipeline register (to propagate enable signal)
    reg [3:0] mul_en_out_reg;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: Each partial product is either mul_a_reg or zero based on mul_b_reg bit
    wire [15:0] partial_product [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_product[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums
    reg [15:0] sum_stage1; // sum of partial_product[0] and partial_product[1]
    reg [15:0] sum_stage2; // sum of partial_product[2] and partial_product[3]
    reg [15:0] sum_stage3; // sum of partial_product[4] and partial_product[5]
    reg [15:0] sum_stage4; // sum of partial_product[6] and partial_product[7]

    reg [15:0] sum_stage12; // sum of sum_stage1 and sum_stage2
    reg [15:0] sum_stage34; // sum of sum_stage3 and sum_stage4

    reg [15:0] mul_out_reg;

    // Process pipeline registers and enable signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 4'd0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            sum_stage1 <= 16'd0;
            sum_stage2 <= 16'd0;
            sum_stage3 <= 16'd0;
            sum_stage4 <= 16'd0;
            sum_stage12 <= 16'd0;
            sum_stage34 <= 16'd0;
            mul_out_reg <= 16'd0;
        end else begin
            // Shift enable register and insert new enable input
            mul_en_out_reg <= {mul_en_out_reg[2:0], mul_en_in};

            // Sample inputs only if mul_en_in is active
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 1: sum pairs of partial products
            // Only update when enable delayed at this stage is active
            if (mul_en_out_reg[0]) begin
                sum_stage1 <= partial_product[0] + partial_product[1];
                sum_stage2 <= partial_product[2] + partial_product[3];
                sum_stage3 <= partial_product[4] + partial_product[5];
                sum_stage4 <= partial_product[6] + partial_product[7];
            end else begin
                sum_stage1 <= 16'd0;
                sum_stage2 <= 16'd0;
                sum_stage3 <= 16'd0;
                sum_stage4 <= 16'd0;
            end

            // Stage 2: sum of sums from stage 1
            if (mul_en_out_reg[1]) begin
                sum_stage12 <= sum_stage1 + sum_stage2;
                sum_stage34 <= sum_stage3 + sum_stage4;
            end else begin
                sum_stage12 <= 16'd0;
                sum_stage34 <= 16'd0;
            end

            // Stage 3: final sum and output register
            if (mul_en_out_reg[2]) begin
                mul_out_reg <= sum_stage12 + sum_stage34;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable signal is the MSB of mul_en_out_reg (indicates valid output)
    assign mul_en_out = mul_en_out_reg[3];

    // Output the product only when mul_en_out is active
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule