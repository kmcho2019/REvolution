module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline depth equals 8 for 8 bits of multiplier
    // Registers for tracking enable signal through pipeline
    reg [7:0] en_pipe;

    // Registers for multiplicand and multiplier in stage 0
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Intermediate sum registers through pipeline stages
    reg [15:0] sum_pipe [0:7];

    integer i;

    // Stage 0: Sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_pipe <= 8'b0;
        end else begin
            en_pipe <= {en_pipe[6:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Partial product and sum pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline sums to zero
            for (i = 0; i < 8; i = i + 1) begin
                sum_pipe[i] <= 16'b0;
            end
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 0: First partial product + initial sum 0
            sum_pipe[0] <= (mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0);

            // Subsequent pipeline stages: add partial product of corresponding bit shifted by bit index
            for (i = 1; i < 8; i = i + 1) begin
                sum_pipe[i] <= sum_pipe[i-1] + (mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0);
            end

            // Output enable is the last bit of enable pipeline
            mul_en_out <= en_pipe[7];

            // Output product is the last pipeline stage sum when output is enabled
            mul_out <= en_pipe[7] ? sum_pipe[7] : 16'b0;
        end
    end

endmodule