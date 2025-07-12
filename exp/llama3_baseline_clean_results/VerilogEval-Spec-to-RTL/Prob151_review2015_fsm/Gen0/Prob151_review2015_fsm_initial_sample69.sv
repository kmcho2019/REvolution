module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// State encoding
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE,
    RESET
} state, next_state;

// Internal signals
logic [3:0] shift_cnt;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_cnt <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            if (shift_cnt == 4'd3) begin
                shift_cnt <= 0;
            end else begin
                shift_cnt <= shift_cnt + 1'b1;
            end
        end else begin
            shift_cnt <= 0;
        end
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            // Detect pattern 1101 on data input pin (assumed handled by a separate module)
            // For simplicity, we assume the detection is done by an external module
            if (/* pattern detected */) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            if (shift_cnt == 4'd3) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case (state)
        SHIFT: shift_ena = 1'b1;
        COUNT: counting = 1'b1;
        DONE: done = 1'b1;
        default: ;
    endcase
end

endmodule