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
reg [2:0] count;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        count <= 3'b000;
        mul_en_out_reg <= 1'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_out_reg <= 16'b0; // Reset mul_out_reg
            count <= 3'b000; // Reset count
            mul_en_out_reg <= 1'b1;
        end else begin
            if (count < 3'b111 && mul_en_out_reg) begin
                if (mul_b_reg[count]) begin
                    mul_out_reg <= mul_out_reg + (mul_a_reg << count);
                end
                count <= count + 1'b1;
            end

            if (count == 3'b111 && mul_en_out_reg) begin
                mul_en_out_reg <= 1'b0;
            end
        end
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule