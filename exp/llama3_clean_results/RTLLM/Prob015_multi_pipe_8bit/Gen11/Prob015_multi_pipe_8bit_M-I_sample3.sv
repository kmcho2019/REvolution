// multi_pipe_8bit.v
module multi_pipe_8bit (
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
reg [3:0] state;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        state <= 4'd0;
        mul_out_reg <= 16'd0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in && (state == 4'd0)) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        state <= 4'd1;
    end else if (state == 4'd1) begin
        state <= 4'd2;
    end else if (state == 4'd2) begin
        state <= 4'd3;
        mul_en_out_reg <= 1'b1;
    end else if (state == 4'd3) begin
        state <= 4'd0;
        mul_en_out_reg <= 1'b0;
    end
end

// Partial product generation and addition
always @ (posedge clk) begin
    if (state == 4'd1) begin
        mul_out_reg <= 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                mul_out_reg <= mul_out_reg + ({8'd0, mul_a_reg} << i);
            end
        end
    end
end

// Output stage
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'd0;

endmodule