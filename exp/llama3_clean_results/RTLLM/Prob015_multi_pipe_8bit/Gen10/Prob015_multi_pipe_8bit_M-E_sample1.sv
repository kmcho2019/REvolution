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

// Input Buffer
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
reg [15:0] pp [7:0];
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            pp[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                pp[i] <= {8'b0, mul_a_reg} << i;
            end else begin
                pp[i] <= 16'b0;
            end
        end
    end
end

// Partial Product Accumulation
reg [15:0] sum [3:0];
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 4; i++) begin
            sum[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        sum[0] <= pp[0] + pp[1];
        sum[1] <= pp[2] + pp[3];
        sum[2] <= pp[4] + pp[5];
        sum[3] <= pp[6] + pp[7];
    end else begin
        sum[0] <= sum[0] + pp[2];
        sum[1] <= sum[1] + pp[3];
        sum[2] <= sum[2] + pp[6];
        sum[3] <= sum[3] + pp[7];
    end
end

// Final Product Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3];
    end
end

// Output Register
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule