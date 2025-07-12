module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] sum [8:0];
reg [15:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (i = 0; i <= 8; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
        mul_en_out <= 0;
        mul_out <= 0;
    end else if (mul_en_in) begin
        // Input control and register stage
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;

        // Partial product generation and partial sum calculation stage
        for (i = 0; i <= 7; i++) begin
            if (mul_b_reg[i]) begin
                sum[i] <= sum[i] + (mul_a_reg << i);
            end else begin
                sum[i] <= sum[i];
            end
        end
        sum[8] <= sum[8] + sum[7];

        // Final product calculation stage
        mul_out_reg <= sum[8];

        // Output assignment stage
        mul_en_out <= mul_en_out_reg[7];
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end else begin
        mul_en_out_reg <= {1'b0, mul_en_out_reg[7:1]};
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (i = 0; i <= 8; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
        mul_en_out <= 0;
        mul_out <= 0;
    end
end

endmodule