module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

wire [15:0] temp;

reg [15:0] sum;

reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial Product Generation
assign temp = (mul_b[0]? mul_a : 8'b0) | 
              ({8'b0, mul_b[1]? mul_a : 8'b0}) | 
              ({16'b0, mul_b[2]? mul_a : 8'b0}) | 
              ({24'b0, mul_b[3]? mul_a : 8'b0}) | 
              ({32'b0, mul_b[4]? mul_a : 8'b0}) | 
              ({40'b0, mul_b[5]? mul_a : 8'b0}) | 
              ({48'b0, mul_b[6]? mul_a : 8'b0}) | 
              ({56'b0, mul_b[7]? mul_a : 8'b0});

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'b0;
    end else if (mul_en_in) begin
        sum <= temp;
    end else begin
        sum <= sum;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output Assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule