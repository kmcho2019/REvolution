module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

typedef enum logic [2:0] {IDLE, SHIFT, COUNT, DONE_WAIT, DONE_ACK} state_t;
state_t state, next_state;

reg [3:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                if (data == 1) begin // pattern detected, go to SHIFT state
                    next_state <= SHIFT;
                    shift_count <= 0;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin // 4 bits shifted, go to COUNT state
                    next_state <= COUNT;
                end else begin
                    next_state <= SHIFT;
                end
            end
            COUNT: begin
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
                if (done_counting == 1) begin // counters finished counting, go to DONE_WAIT state
                    next_state <= DONE_WAIT;
                end else begin
                    next_state <= COUNT;
                end
            end
            DONE_WAIT: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack == 1) begin // user acknowledged, go to DONE_ACK state
                    next_state <= DONE_ACK;
                end else begin
                    next_state <= DONE_WAIT;
                end
            end
            DONE_ACK: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule