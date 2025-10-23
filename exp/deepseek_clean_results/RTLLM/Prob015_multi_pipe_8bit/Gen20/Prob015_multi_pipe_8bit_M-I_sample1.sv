module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] carry_save [1:0]; // Carry-save registers
    reg [15:0] sum_reg;          // Final sum register
    reg [1:0] en_pipeline;       // Reduced enable pipeline

    // Gated partial products
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (b_reg[i] & en_pipeline[0]) ? (a_reg << i) : 16'b0;
        end
    endgenerate

    // First stage carry-save addition
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2];
    wire [15:0] sum1 = pp[3] + pp[4] + pp[5];
    wire [15:0] sum2 = pp[6] + pp[7];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            carry_save[0] <= 16'b0;
            carry_save[1] <= 16'b0;
            sum_reg <= 16'b0;
            en_pipeline <= 2'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and first level addition
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: Carry-save accumulation
            carry_save[0] <= sum0;
            carry_save[1] <= sum1 + sum2;

            // Final sum
            sum_reg <= carry_save[0] + carry_save[1];

            // Enable pipeline and output
            en_pipeline <= {en_pipeline[0], mul_en_in};
            mul_en_out <= en_pipeline[1];
            if (en_pipeline[1]) begin
                mul_out <= sum_reg;
            end else begin
                mul_out <= 16'b0;
            end
        end
    end

endmodule