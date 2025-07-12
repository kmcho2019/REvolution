module multi_pipe_8bit (
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
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
    end else begin
        // Input control
        mul_en_out_reg <= mul_en_in;

        // Input registers
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Partial product generation and sum calculation
        if (mul_en_in) begin
            for (int i = 0; i < 8; i++) begin
                if (mul_b_reg[i]) begin
                    sum[i] <= mul_a_reg << i;
                end else begin
                    sum[i] <= 0;
                end
            end
        end else begin
            for (int i = 0; i < 8; i++) begin
                sum[i] <= 0;
            end
        end

        // Final product calculation
        if (mul_en_in) begin
            mul_out_reg <= sum[0];
            for (int i = 1; i < 8; i++) begin
                mul_out_reg <= mul_out_reg + sum[i];
            end
        end else begin
            mul_out_reg <= 0;
        end
    end
end

// Output assignment
always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg[7];
    if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 0;
    end
end

endmodule