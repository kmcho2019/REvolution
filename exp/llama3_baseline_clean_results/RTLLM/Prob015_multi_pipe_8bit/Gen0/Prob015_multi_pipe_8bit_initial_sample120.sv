module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] mul_en_out_reg;

// Partial product generation
wire [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;

// Partial sum calculation
reg [15:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;

// Final product calculation
reg [15:0] mul_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        sum4 <= 16'b0;
        sum5 <= 16'b0;
        sum6 <= 16'b0;
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        
        // Partial product generation
        temp0 <= {8'b0, mul_a_reg};
        temp1 <= (mul_b_reg[0]) ? {8'b0, mul_a_reg} : 16'b0;
        temp2 <= (mul_b_reg[1]) ? {mul_a_reg, 8'b0} : 16'b0;
        temp3 <= (mul_b_reg[2]) ? {2{mul_a_reg}, 6'b0} : 16'b0;
        temp4 <= (mul_b_reg[3]) ? {3{mul_a_reg}, 5'b0} : 16'b0;
        temp5 <= (mul_b_reg[4]) ? {4{mul_a_reg}, 4'b0} : 16'b0;
        temp6 <= (mul_b_reg[5]) ? {5{mul_a_reg}, 3'b0} : 16'b0;
        temp7 <= (mul_b_reg[6]) ? {6{mul_a_reg}, 2'b0} : 16'b0;
        
        // Partial sum calculation
        sum0 <= temp0 + temp1;
        sum1 <= sum0 + temp2;
        sum2 <= sum1 + temp3;
        sum3 <= sum2 + temp4;
        sum4 <= sum3 + temp5;
        sum5 <= sum4 + temp6;
        sum6 <= sum5 + temp7;
        
        // Final product calculation
        mul_out_reg <= sum6;
        
        // Output assignment
        if (mul_en_out_reg[7]) begin
            mul_en_out <= 1'b1;
            mul_out <= mul_out_reg;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end else begin
        mul_en_out_reg <= {1'b0, mul_en_out_reg[7:1]};
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        sum4 <= 16'b0;
        sum5 <= 16'b0;
        sum6 <= 16'b0;
        mul_out_reg <= 16'b0;
    end
end

endmodule