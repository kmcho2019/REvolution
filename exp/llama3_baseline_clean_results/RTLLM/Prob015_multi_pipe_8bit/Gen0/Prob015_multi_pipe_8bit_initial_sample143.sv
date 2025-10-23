module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp [7:0];

// Input control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input registers
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

// Partial product generation
integer i;
always @(*) begin
    for (i = 0; i < 8; i++) begin
        temp[i] = (mul_a_reg << i) * mul_b_reg[i];
    end
end

// Partial sum calculation
reg [15:0] sum [7:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
    end else if (mul_en_in) begin
        sum[0] <= temp[0];
        for (i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
    end else begin
        sum[0] <= sum[0];
        for (i = 1; i < 8; i++) begin
            sum[i] <= sum[i];
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum[7];
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output assignment
always @(*) begin
    if (mul_en_out) begin
        mul_out = mul_out_reg;
    end else begin
        mul_out = 0;
    end
end

endmodule