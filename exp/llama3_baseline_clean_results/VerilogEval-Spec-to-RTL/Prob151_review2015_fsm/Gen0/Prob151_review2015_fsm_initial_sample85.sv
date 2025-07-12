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

// Enum for states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

// Pattern detector
logic [3:0] pattern;
always_ff @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else begin
        pattern <= {pattern[2:0], data};
    end
end

// Shift counter
logic [1:0] shift_count;
always_ff @(posedge clk) begin
    if (reset || (state == IDLE)) begin
        shift_count <= 2'b00;
    end else if (state == SHIFT) begin
        shift_count <= shift_count + 1'b1;
    end
end

// State machine
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_count == 2'd3) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (done_counting) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end
        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Outputs
always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case (state)
        SHIFT: begin
            shift_ena = 1'b1;
        end
        COUNTING: begin
            counting = 1'b1;
        end
        DONE: begin
            done = 1'b1;
        end
        default: begin
        end
    endcase
end

endmodule