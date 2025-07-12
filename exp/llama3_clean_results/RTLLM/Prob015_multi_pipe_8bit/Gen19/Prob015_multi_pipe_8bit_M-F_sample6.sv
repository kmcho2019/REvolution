module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input Buffering Stage
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_in_reg;
reg mul_start;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_in_reg <= 1'b0;
        mul_start <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_in_reg <= 1'b1;
        mul_start <= 1'b1;
    end else begin
        mul_en_in_reg <= 1'b0;
        mul_start <= 1'b0;
    end
end

// Multiplication Stage
reg [15:0] product_reg;
reg [2:0] counter;
reg [15:0] temp_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 16'b0;
        counter <= 3'b0;
        temp_reg <= 16'b0;
    end else if (mul_start) begin
        if (counter == 3'b0) begin
            product_reg <= 16'b0;
            counter <= counter + 1'b1;
        end else if (counter < 3'b111) begin
            if (mul_b_reg[counter-1]) begin
                temp_reg <= mul_a_reg << (counter-1);
            end else begin
                temp_reg <= 16'b0;
            end
            product_reg <= product_reg + temp_reg;
            counter <= counter + 1'b1;
        end else begin
            counter <= 3'b0;
        end
    end else begin
        product_reg <= 16'b0;
        counter <= 3'b0;
        temp_reg <= 16'b0;
    end
end

// Output Buffering Stage
reg [15:0] mul_out_reg;
reg mul_en_out_reg;
reg mul_done;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
        mul_done <= 1'b0;
    end else if (counter == 3'b111) begin
        mul_out_reg <= product_reg;
        mul_done <= 1'b1;
    end else if (mul_done) begin
        mul_en_out_reg <= 1'b1;
        mul_done <= 1'b0;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule