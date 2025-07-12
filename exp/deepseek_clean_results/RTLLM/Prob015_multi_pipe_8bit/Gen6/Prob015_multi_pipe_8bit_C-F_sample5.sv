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
    reg [15:0] partial_sum_reg, final_sum_reg;

    // Gated partial products
    wire [15:0] partial_products [7:0];
    wire [7:0] b_gated = mul_b_reg & {8{en_pipeline[0]}};

    // Generate gated partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign partial_products[i] = b_gated[i] ? {8'b0, mul_a_reg} << i : 16'b0;
        end
    endgenerate

    // Balanced adder tree (4+4 then sum)
    wire [15:0] sum_lower = partial_products[0] + partial_products[1] + 
                           partial_products[2] + partial_products[3];
    wire [15:0] sum_upper = partial_products[4] + partial_products[5] + 
                           partial_products[6] + partial_products[7];
    wire [15:0] total_sum = sum_lower + sum_upper;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_pipeline <= 2'b0;
            partial_sum_reg <= 16'b0;
            final_sum_reg <= 16'b0;
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            // Stage 1: Input registration
            en_pipeline <= {en_pipeline[0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 2: Partial sum calculation
            partial_sum_reg <= total_sum;

            // Stage 3: Final result registration
            final_sum_reg <= partial_sum_reg;

            // Output with enable gating
            mul_out <= en_pipeline[1] ? final_sum_reg : 16'b0;
            mul_en_out <= en_pipeline[1];
        end
    end

endmodule