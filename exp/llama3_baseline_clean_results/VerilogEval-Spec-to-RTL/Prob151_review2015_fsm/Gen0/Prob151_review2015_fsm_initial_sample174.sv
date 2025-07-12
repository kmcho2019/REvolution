module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

logic [3:0] shift_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            if (shift_count < 4) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 0;
            end
        end
    end
end

always_comb begin
    next_state = state;
    shift_ena = 0;
    counting = 0;
    done = 0;
    case (state)
        IDLE: begin
            if (data == 1'b1) begin // start of pattern 1101
                next_state = IDLE;
            end else if (data == 1'b0) begin // 1101 pattern not started
                next_state = IDLE;
            end else begin // 1101 pattern not started
                next_state = IDLE;
            end
            // check for pattern 1101
            if (/* assume pattern detected */) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            shift_ena = 1;
            if (shift_count == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            counting = 1;
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule