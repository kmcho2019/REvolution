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
    COUNT,
    DONE
} state, next_state;

// Pattern detection variables
logic [3:0] pattern_detected;
logic [3:0] shift_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detected <= 4'b0000;
        shift_count <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == IDLE) begin
            // Shift in the detected pattern
            pattern_detected <= {pattern_detected[2:0], data};
        end else if (state == SHIFT) begin
            // Decrement shift count
            shift_count <= shift_count - 1'b1;
        end else if (state == COUNT) begin
            // Do nothing, just wait
        end else if (state == DONE) begin
            // Do nothing, just wait for ack
        end
    end
end

always_comb begin
    case (state)
        IDLE: begin
            // Check for pattern detection
            if (pattern_detected == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            // Check if shift count is zero
            if (shift_count == 4'b0000) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            // Check if counting is done
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            // Check if ack is received
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always_comb begin
    case (state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        SHIFT: begin
            // Assert shift_ena for 4 clock cycles
            shift_ena = (shift_count!= 4'b0000)? 1'b1 : 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        COUNT: begin
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        DONE: begin
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

// Initialize shift count in IDLE state
always_comb begin
    if (state == IDLE) begin
        shift_count = 4'b0000;
    end else if (state == SHIFT) begin
        shift_count = (shift_count == 4'b0000)? 4'b0000 : shift_count;
    end
end

endmodule