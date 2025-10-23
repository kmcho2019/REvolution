module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp_low_reg, pp_high_reg;
    reg [15:0] sum_reg;
    reg [2:0] en_pipeline;  // Reduced to 3 bits for 3-stage pipeline

    // Partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // First stage sums (split into low and high nibbles)
    wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];

    // Final sum
    wire [15:0] final_sum = pp_low_reg + pp_high_reg;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_low_reg <= 16'b0;
            pp_high_reg <= 16'b0;
            sum_reg <= 16'b0;
            en_pipeline <= 3'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: Partial sums registration
            pp_low_reg <= sum_low;
            pp_high_reg <= sum_high;

            // Stage 3: Final result
            sum_reg <= final_sum;

            // Enable shift register
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    always @(*) begin
        mul_en_out = en_pipeline[2];
        mul_out = en_pipeline[2] ? sum_reg : 16'b0;
    end

endmodule