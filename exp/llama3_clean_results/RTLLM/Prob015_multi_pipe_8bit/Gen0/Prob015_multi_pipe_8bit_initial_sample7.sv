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
reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product generation
wire [15:0] temp;

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
        temp[0]  = (mul_b[0] == 1) ? {8'd0, mul_a} : 16'd0;
        temp[1]  = (mul_b[1] == 1) ? {7'd0, mul_a, 1'd0} : 16'd0;
        temp[2]  = (mul_b[2] == 1) ? {6'd0, mul_a, 2'd0} : 16'd0;
        temp[3]  = (mul_b[3] == 1) ? {5'd0, mul_a, 3'd0} : 16'd0;
        temp[4]  = (mul_b[4] == 1) ? {4'd0, mul_a, 4'd0} : 16'd0;
        temp[5]  = (mul_b[5] == 1) ? {3'd0, mul_a, 5'd0} : 16'd0;
        temp[6]  = (mul_b[6] == 1) ? {2'd0, mul_a, 6'd0} : 16'd0;
        temp[7]  = (mul_b[7] == 1) ? {1'd0, mul_a, 7'd0} : 16'd0;

        // Partial sum calculation
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];

        // Final product calculation
        mul_out_reg <= sum;

        // Output assignment
        mul_en_out <= mul_en_out_reg[0];
        mul_out <= (mul_en_out) ? mul_out_reg : 16'd0;
    end
end

endmodule