module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [0:0] mul_en_out_reg; // register to hold the input enable signal
reg [7:0] mul_a_reg;      // register to hold the multiplicand
reg [7:0] mul_b_reg;      // register to hold the multiplier
wire [15:0] temp;         // wire to hold the partial products
reg [15:0] sum;           // register to hold the partial sums
reg [15:0] mul_out_reg;   // register to hold the final product

// Input control logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        sum <= 16'b0;
        mul_out_reg <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
        sum <= {sum[15:8], sum[7:0]} + (mul_a_reg * {8'b0, mul_b_reg[0]});
        if (mul_b_reg[7:1] == 7'b0) begin
            mul_out_reg <= sum;
        end
    end
end

// Partial product generation
assign temp = mul_a_reg * mul_b_reg;

// Output assignment
always @ (*) begin
    if (mul_en_out_reg) begin
        mul_en_out = 1'b1;
        mul_out = mul_out_reg;
    end else begin
        mul_en_out = 1'b0;
        mul_out = 16'b0;
    end
end

endmodule