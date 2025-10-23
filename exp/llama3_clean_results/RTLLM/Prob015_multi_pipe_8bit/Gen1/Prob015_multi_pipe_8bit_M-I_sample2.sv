module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input control logic
reg [7:0] mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {7'd0, 1'b1};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end
assign mul_en_out = mul_en_out_reg[7];

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation and sum calculation
reg [15:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'd0;
    end else if (mul_en_in) begin
        sum <= 16'd0;
    end else begin
        if (mul_b_reg[0]) begin
            sum <= sum + mul_a_reg;
        end
        mul_b_reg <= mul_b_reg >> 1;
        mul_a_reg <= mul_a_reg << 1;
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_out) begin
        mul_out <= sum;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule