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

// Define states
typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE
} state_type;

// Current state and next state
state_type current_state, next_state;

// Counter to keep track of number of bits shifted
reg [1:0] shift_counter;

// Shift register to keep track of pattern
reg [3:0] pattern;

always @(*) begin
    case (current_state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_counter == 4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNT;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        shift_counter <= 0;
        pattern <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == SHIFT) begin
            shift_counter <= shift_counter + 1;
        end else if (current_state == IDLE) begin
            shift_counter <= 0;
        end
        if (current_state == IDLE || current_state == SHIFT) begin
            pattern <= {pattern[2:0], data};
        end else begin
            pattern <= pattern;
        end
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
        SHIFT: begin
            shift_ena = 1;
            counting = 0;
            done = 0;
        end
        COUNT: begin
            shift_ena = 0;
            counting = 1;
            done = 0;
        end
        DONE: begin
            shift_ena = 0;
            counting = 0;
            done = 1;
        end
        default: begin
            shift_ena = 0;
            counting = 0;
            done = 0;
        end
    endcase
end

endmodule