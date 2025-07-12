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
reg [2:0] cnt;
reg [1:0] state;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'b00; // IDLE state
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        cnt <= 3'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (mul_en_in) begin
                    state <= 2'b01; // MULT state
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    mul_out_reg <= 16'b0;
                    cnt <= 3'b0;
                end
            end
            2'b01: begin // MULT state
                if (cnt < 8) begin
                    if (mul_b_reg[cnt]) begin
                        mul_out_reg <= mul_out_reg + ({8'b0, mul_a_reg} << cnt);
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    state <= 2'b00; // IDLE state
                end
            end
            default: state <= 2'b00; // IDLE state
        endcase
    end
end

assign mul_en_out = (state == 2'b01 && cnt == 8) ? 1'b1 : 1'b0;
assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule