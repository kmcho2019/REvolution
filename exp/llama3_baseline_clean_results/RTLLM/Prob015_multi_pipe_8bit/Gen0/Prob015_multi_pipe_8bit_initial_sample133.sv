module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [15:0] temp;
reg [15:0] sum [7:1];
reg [15:0] mul_out_reg;

// Input Control and Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial Product Generation
always @(*) begin
    temp = 0;
    for (int i = 0; i < 8; i++) begin
        if (mul_b_reg[i]) begin
            temp = temp + (mul_a_reg << i);
        end
    end
end

// Partial Sum Calculation
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 1; i < 8; i++) begin
            sum[i] <= 0;
        end
    end else begin
        for (i = 1; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                sum[i] <= sum[i] + (mul_a_reg << i);
            end else begin
                sum[i] <= sum[i];
            end
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= temp;
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        mul_en_out <= mul_en_out_reg[7];
        if (mul_en_out_reg[7]) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end
end

endmodule