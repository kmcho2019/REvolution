module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input control signals
reg mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product generation
reg [15:0] temp [7:0];

// Partial sum calculation
reg [15:0] sum;

// Final product calculation
reg [15:0] mul_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (int i = 0; i < 8; i++) begin
            temp[i] <= 0;
        end
        sum <= 0;
        mul_out_reg <= 0;
    end else begin
        // Input control
        if (mul_en_in) begin
            mul_en_out_reg <= 1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 0;
        end

        // Partial product generation
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1) begin
                temp[i] <= {8'd0, mul_a_reg} << i;
            end else begin
                temp[i] <= 0;
            end
        end

        // Partial sum calculation
        sum <= 0;
        for (int i = 0; i < 8; i++) begin
            sum <= sum + temp[i];
        end

        // Final product calculation
        mul_out_reg <= sum;

        // Output assignment
        mul_en_out <= mul_en_out_reg;
        mul_out <= (mul_en_out)? mul_out_reg : 16'd0;
    end
end

endmodule