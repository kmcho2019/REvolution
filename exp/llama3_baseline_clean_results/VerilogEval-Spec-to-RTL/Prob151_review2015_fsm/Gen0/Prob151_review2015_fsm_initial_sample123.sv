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

// Define the states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state, next_state;

// Define the shift counter
logic [1:0] shift_count;
logic [1:0] next_shift_count;

// Define the bits for the pattern
logic [3:0] pattern;

// Define the current bit position in the pattern
logic [1:0] pattern_count;
logic [1:0] next_pattern_count;

always_comb begin
    next_state = state;
    next_shift_count = shift_count;
    next_pattern_count = pattern_count;

    case(state)
        IDLE: begin
            if (reset) begin
                next_state = IDLE;
            end
            else if (pattern_count == 4'b0 && data == 1'b1) begin
                pattern_count = pattern_count + 1'b1;
            end
            else if (pattern_count == 4'b1 && data == 1'b1) begin
                pattern_count = pattern_count + 1'b1;
            end
            else if (pattern_count == 4'b10 && data == 1'b0) begin
                pattern_count = pattern_count + 1'b1;
            end
            else if (pattern_count == 4'b11 && data == 1'b1) begin
                next_state = SHIFT;
                shift_count = 4'b0;
            end
            else begin
                pattern_count = 4'b0;
            end
        end

        SHIFT: begin
            if (shift_count < 4) begin
                next_shift_count = shift_count + 1'b1;
                if (shift_count == 4'b111) begin
                    next_state = COUNT;
                end
            end
            else begin
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
                pattern_count = 4'b0;
                shift_count = 4'b0;
            end
        end

        default: next_state = IDLE;

    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'b0;
        pattern_count <= 4'b0;
    end
    else begin
        state <= next_state;
        shift_count <= next_shift_count;
        pattern_count <= next_pattern_count;
    end
end

// Output logic
always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;

    case(state)
        IDLE: begin
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end

        SHIFT: begin
            shift_ena = 1'b1;
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

endmodule