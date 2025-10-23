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
reg [3:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
        counter <= 4'b0;
    end else begin
        case (counter)
            4'b0000: begin
                if (mul_en_in) begin
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    mul_en_out_reg <= 1'b1;
                    counter <= 4'b0001;
                end
            end
            4'b0001: begin
                mul_out_reg <= 16'b0;
                counter <= 4'b0010;
            end
            4'b0010: begin
                for (int i = 0; i < 8; i++) begin
                    if (mul_b_reg[i]) begin
                        mul_out_reg <= mul_out_reg + (mul_a_reg << i);
                    end
                end
                counter <= 4'b0011;
            end
            4'b0011: begin
                mul_en_out_reg <= 1'b0;
                counter <= 4'b0000;
            end
            default: counter <= 4'b0000;
        endcase
    end
end

assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;
assign mul_en_out = mul_en_out_reg;

endmodule