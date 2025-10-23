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
reg mul_en_out_reg;

// FSM states
enum logic [1:0] {IDLE, RUNNING, DONE} state, next_state;

// Combinational logic to calculate next state and output
always_comb begin
    case (state)
        IDLE: begin
            if (mul_en_in) begin
                next_state = RUNNING;
            end else begin
                next_state = IDLE;
            end
        end
        RUNNING: begin
            if (cnt == 8) begin
                next_state = DONE;
            end else begin
                next_state = RUNNING;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update current state and output registers
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
                    mul_a_reg <= mul_a;
                    mul_b_reg <= mul_b;
                    mul_out_reg <= 16'b0;
                    cnt <= 3'b0;
                end
            end
            RUNNING: begin
                if (mul_b_reg[cnt]) begin
                    mul_out_reg <= mul_out_reg + ({8'b0, mul_a_reg} << cnt);
                end
                cnt <= cnt + 1'b1;
            end
            DONE: begin
                mul_en_out_reg <= 1'b1;
            end
            default: begin
                // Do nothing
            end
        endcase
        state <= next_state;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg && (state == DONE)) ? mul_out_reg : 16'b0;

endmodule