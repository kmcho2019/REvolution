module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [1:0] en_pipeline;  // Compact enable pipeline
    reg [15:0] sum_low_reg, sum_high_reg;
    reg [15:0] final_sum_reg;

    // Gated partial products
    wire [15:0] partial_products [7:0];
    wire [7:0] b_gated = mul_b_reg & {8{en_pipeline[0]}};  // Enable gating

    // Generate partial products with structural generation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign partial_products[i] = b_gated[i] ? {8'b0, mul_a_reg} << i : 16'b0;
        end
    endgenerate

    // Balanced adder tree (3 levels)
    wire [15:0] sum01 = partial_products[0] + partial_products[1];
    wire [15:0] sum23 = partial_products[2] + partial_products[3];
    wire [15:0] sum45 = partial_products[4] + partial_products[5];
    wire [15:0] sum67 = partial_products[6] + partial_products[7];
    
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    wire [15:0] final_sum = sum_low_reg + sum_high_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset only essential registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            sum_low_reg <= 16'b0;
            sum_high_reg <= 16'b0;
            final_sum_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Input registration
            en_pipeline <= {en_pipeline[0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 2: Intermediate sums
            sum_low_reg <= sum_low;
            sum_high_reg <= sum_high;

            // Stage 3: Final sum
            final_sum_reg <= final_sum;
        end
    end

    // Output assignment with enable gating
    always @(*) begin
        mul_en_out = en_pipeline[1];
        mul_out = en_pipeline[1] ? final_sum_reg : 16'b0;
    end

endmodule