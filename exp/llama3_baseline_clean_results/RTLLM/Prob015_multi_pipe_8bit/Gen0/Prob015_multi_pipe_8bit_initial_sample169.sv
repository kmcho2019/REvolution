module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Control: sample input enable signal and derive output enable signal
reg [0:0] mul_en_out_reg;

// Input Registers: store input multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial Product Generation: generate partial products
wire [15:0] temp [7:0];

// Partial Sum Calculation: calculate partial sums
reg [15:0] sum [7:0];

// Final Product Calculation: calculate final product
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        
        // Partial Product Generation
        for (int i = 0; i < 8; i++) begin
            temp[i] = (mul_b_reg[i] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
        end
        
        // Partial Sum Calculation
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + (temp[i] << i);
        end
        
        // Final Product Calculation
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
always @(*) begin
    if (mul_en_out_reg[0]) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
    mul_en_out <= mul_en_out_reg[0];
end

endmodule