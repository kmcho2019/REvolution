module multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [1:0] state;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        state <= 2'b00;
        mul_en_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    state <= 2'b01;
                    mul_en_out_reg <= 1'b1;
                end else begin
                    mul_en_out_reg <= 1'b0;
                end
            end
            2'b01: begin
                mul_out_reg <= 16'b0;
                state <= 2'b10;
            end
            2'b10: begin
                mul_out_reg <= mul_out_reg + (mul_a_reg * mul_b_reg);
                state <= 2'b11;
            end
            2'b11: begin
                mul_en_out_reg <= 1'b0;
                state <= 2'b00;
            end
        endcase
    end
end

always @(posedge clk) begin
    mul_en_out <= mul_en_out_reg;
    if (mul_en_out_reg) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule