module multi_pipe_8bit (
    input clk, 
    input rst_n, 
    input mul_en_in, 
    input [7:0] mul_a, 
    input [7:0] mul_b, 
    output mul_en_out, 
    output [15:0] mul_out
);

// Input control register
reg mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1;
    end else begin
        mul_en_out_reg <= 0;
    end
end

// Output enable signal
assign mul_en_out = mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Recursive multiplication and addition
reg [15:0] product;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product <= 0;
    end else if (mul_en_in) begin
        product <= 0;
    end else if (mul_en_out_reg) begin
        if (mul_b_reg[0] == 1) begin
            product <= product + mul_a_reg;
        end
        product <= product << 1;
        mul_b_reg <= mul_b_reg >> 1;
    end else begin
        product <= product;
    end
end

// Final product calculation and output assignment
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_out) begin
        mul_out_reg <= product;
    end else begin
        mul_out_reg <= 0;
    end
end

// Output assignment
assign mul_out = mul_out_reg;

endmodule