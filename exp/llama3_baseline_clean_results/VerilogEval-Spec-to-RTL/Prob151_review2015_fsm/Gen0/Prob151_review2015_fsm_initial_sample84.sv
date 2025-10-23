module TopModule(
    input           clk,
    input           reset,
    input           data,
    input           done_counting,
    input           ack,
    output          shift_ena,
    output          counting,
    output          done
);

    // Enum for states
    enum logic [2:0] {IDLE, DETECT_PATTERN, SHIFT_IN_DURATION, WAIT_FOR_COUNTING, WAIT_FOR_ACK} state, next_state;
    logic [3:0] shift_count;

    // Next state logic
    always_comb begin
        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = IDLE;
                end else if (data == 1'b1) begin
                    next_state = DETECT_PATTERN;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT_PATTERN: begin
                if (reset) begin
                    next_state = IDLE;
                end else if (data == 1'b1) begin
                    next_state = DETECT_PATTERN;
                end else if (data == 1'b0) begin
                    next_state = SHIFT_IN_DURATION;
                end else begin
                    next_state = DETECT_PATTERN;
                end
            end
            SHIFT_IN_DURATION: begin
                if (reset) begin
                    next_state = IDLE;
                end else if (shift_count == 4'd3) begin
                    next_state = WAIT_FOR_COUNTING;
                end else begin
                    next_state = SHIFT_IN_DURATION;
                end
            end
            WAIT_FOR_COUNTING: begin
                if (reset) begin
                    next_state = IDLE;
                end else if (done_counting) begin
                    next_state = WAIT_FOR_ACK;
                end else begin
                    next_state = WAIT_FOR_COUNTING;
                end
            end
            WAIT_FOR_ACK: begin
                if (reset) begin
                    next_state = IDLE;
                end else if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_FOR_ACK;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always_comb begin
        case (state)
            IDLE: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            DETECT_PATTERN: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            SHIFT_IN_DURATION: begin
                shift_ena = 1'b1;
                counting = 1'b0;
                done = 1'b0;
            end
            WAIT_FOR_COUNTING: begin
                shift_ena = 1'b0;
                counting = 1'b1;
                done = 1'b0;
            end
            WAIT_FOR_ACK: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
            end
            default: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 4'd0;
        end else begin
            state <= next_state;
            if (state == SHIFT_IN_DURATION) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 4'd0;
            end
        end
    end

endmodule