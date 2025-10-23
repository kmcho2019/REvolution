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
    IDLE = 3'b001,
    SHIFT = 3'b010,
    COUNT = 3'b011,
    DONE_WAIT = 3'b100
} state, next_state;

// Pattern detection variables
logic [3:0] pattern;
logic pattern_detected;

// Shift counter
logic [1:0] shift_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        pattern_detected <= 1'b0;
        shift_count <= 2'b00;
    end else begin
        state <= next_state;
        pattern <= {data, pattern[3:1]};
        if (state == IDLE && pattern == 4'b1101) begin
            pattern_detected <= 1'b1;
        end
        if (state == SHIFT) begin
            shift_count <= shift_count + 1'b1;
        end
    end
end

always_comb begin
    next_state = state;
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            if (shift_count == 2'b11) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE_WAIT;
            end
        end
        DONE_WAIT: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule