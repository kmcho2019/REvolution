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
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    mul_en_out_reg <= 1'b1;
                    state <= 3'b001;
                end
            end
            3'b001: begin
                mul_out_reg <= 16'b0;
                state <= 3'b010;
            end
            3'b010: begin
                for (int i = 0; i < 8; i++) begin
                    if (mul_b_reg[i]) begin
                        mul_out_reg <= mul_out_reg + (mul_a_reg << i);
                    end
                end
                state <= 3'b011;
            end
            3'b011: begin
                mul_en_out_reg <= 1'b0;
                state <= 3'b000;
            end
        endcase
    end
end

assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;
assign mul_en_out = mul_en_out_reg;

endmodule