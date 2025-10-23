module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

// Define shift register
logic [3:0] shift_reg;

// Define shift counter
logic [1:0] shift_cnt;

// Define flag for done_counting
logic done_counting_flag;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'b0000;
        shift_cnt <= 2'b00;
        done_counting_flag <= 1'b0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                shift_cnt <= shift_cnt + 1'b1;
                if (shift_cnt == 2'b11) begin
                    state <= COUNTING;
                end else begin
                    state <= SHIFT;
                end
            end
            COUNTING: begin
                if (done_counting) begin
                    state <= DONE;
                end else begin
                    state <= COUNTING;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end else begin
                    state <= DONE;
                end
            end
        endcase
        case (state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule