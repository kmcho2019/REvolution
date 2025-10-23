module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;
reg [15:0] partial_product [7:0];
reg [15:0] partial_sum;
reg [2:0] counter;

// Input Buffering
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Bitwise Multiplication
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            partial_product[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                partial_product[i] <= {8'b0, mul_a_reg} << i;
            end else begin
                partial_product[i] <= 16'b0;
            end
        end
    end
end

// Partial Sum Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_in) begin
        partial_sum <= partial_product[0];
    end else begin
        partial_sum <= partial_sum + partial_product[counter];
        counter <= counter + 1;
    end
end

// Final Product Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (counter == 7) begin
        mul_out_reg <= partial_sum;
        counter <= 0;
    end
end

// Output Register
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (counter == 7) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule