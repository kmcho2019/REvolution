module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Define FSM states
enum logic [1:0] {IDLE, INPUT_BUFFER, PARTIAL_PRODUCT, FINAL_PRODUCT} state, next_state;

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;
reg [2:0] cnt;

// FSM logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        cnt <= 3'b0;
        mul_en_out_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (mul_en_in) begin
                    state <= INPUT_BUFFER;
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    cnt <= 3'b0;
                end else begin
                    state <= IDLE;
                end
            end
            INPUT_BUFFER: begin
                state <= PARTIAL_PRODUCT;
            end
            PARTIAL_PRODUCT: begin
                if (cnt < 8) begin
                    if (mul_b_reg[cnt]) begin
                        mul_out_reg <= mul_out_reg + ({8'b0, mul_a_reg} << cnt);
                    end
                    cnt <= cnt + 1'b1;
                end else begin
                    state <= FINAL_PRODUCT;
                end
            end
            FINAL_PRODUCT: begin
                mul_en_out_reg <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule