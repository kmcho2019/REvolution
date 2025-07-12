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
reg [7:0] pp [7:0];
reg [15:0] sum [4:0];

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
            pp[i] <= 8'b0;
        end
    end else if (mul_en_in) begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                pp[i] <= mul_a_reg;
            end else begin
                pp[i] <= 8'b0;
            end
        end
    end
end

// Partial Sum Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 5; i++) begin
            sum[i] <= 16'b0;
        end
    end else if (mul_en_in) begin
        sum[0] <= {8'b0, pp[0]};
        sum[1] <= {8'b0, pp[1]} << 1;
        sum[2] <= {8'b0, pp[2]} << 2;
        sum[3] <= {8'b0, pp[3]} << 3;
        sum[4] <= {8'b0, pp[4]} << 4;
    end else begin
        sum[0] <= sum[0];
        sum[1] <= sum[1] + ({8'b0, pp[1]} << 1);
        sum[2] <= sum[2] + ({8'b0, pp[2]} << 2);
        sum[3] <= sum[3] + ({8'b0, pp[3]} << 3);
        sum[4] <= sum[4] + ({8'b0, pp[4]} << 4);
    end
end

// Carry Accumulation and Final Product Calculation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= pp[5] << 5 + pp[6] << 6 + pp[7] << 7;
    end else begin
        mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4];
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