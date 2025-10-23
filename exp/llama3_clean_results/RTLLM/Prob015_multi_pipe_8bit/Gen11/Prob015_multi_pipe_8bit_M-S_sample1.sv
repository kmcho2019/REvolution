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
reg [2:0] cnt;

// Input Buffer
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        cnt <= 3'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        cnt <= 3'b0;
    end
end

// Partial Product Generation and Accumulation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (cnt < 8) begin
        if (mul_b_reg[cnt]) begin
            mul_out_reg <= mul_out_reg + ({8'b0, mul_a_reg} << cnt);
        end
        cnt <= cnt + 1'b1;
    end else begin
        mul_en_out_reg <= 1'b1;
    end
end

// Output Register
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = (cnt == 8) ? 1'b1 : 1'b0;
assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule