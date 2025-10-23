module multi_pipe_8bit(
    input clk, 
    input rst_n, 
    input mul_en_in, 
    input [7:0] mul_a, 
    input [7:0] mul_b, 
    output reg mul_en_out, 
    output reg [15:0] mul_out
);

reg [0:0] mul_en_out_reg; // register to store input enable signal
reg [7:0] mul_a_reg; // register to store input multiplicand
reg [7:0] mul_b_reg; // register to store input multiplier
reg [15:0] sum; // register to store partial sum
reg [15:0] mul_out_reg; // register to store final product
wire [15:0] temp; // wire to store partial products

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
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
    end
end

// Partial Product Generation
assign temp[0] = (mul_b[0]) ? mul_a : 16'b0;
assign temp[1] = (mul_b[1]) ? {mul_a, 1'b0} : 16'b0;
assign temp[2] = (mul_b[2]) ? {mul_a, 2'b0} : 16'b0;
assign temp[3] = (mul_b[3]) ? {mul_a, 3'b0} : 16'b0;
assign temp[4] = (mul_b[4]) ? {mul_a, 4'b0} : 16'b0;
assign temp[5] = (mul_b[5]) ? {mul_a, 5'b0} : 16'b0;
assign temp[6] = (mul_b[6]) ? {mul_a, 6'b0} : 16'b0;
assign temp[7] = (mul_b[7]) ? {mul_a, 7'b0} : 16'b0;

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'b0;
    end else if (mul_en_in) begin
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_out_reg) begin
        mul_out_reg <= sum;
    end
end

// Output Assignment
always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg;
    if (mul_en_out_reg) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule