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
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;
wire [15:0] temp [7:0];

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
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

// Partial Product Generation
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        assign temp[i] = (mul_b_reg[i] == 1)? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
    end else begin
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 0;
    end
end

endmodule