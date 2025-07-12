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

// Define the states
enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE_ACK
} state, next_state;

// Define the counter for shifting
logic [2:0] shift_count;

// Define the pattern detection
logic [3:0] pattern_detect;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 3'b000;
        pattern_detect <= 4'b0000;
    end else begin
        state <= next_state;
        if (state == IDLE && pattern_detect == 4'b1101) begin
            pattern_detect <= 4'b0000;
        end else if (state == IDLE) begin
            pattern_detect <= {pattern_detect[2:0], data};
        end
        if (state == SHIFT) begin
            shift_count <= shift_count - 1'b1;
        end else begin
            shift_count <= 3'b100;
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
            if (pattern_detect == 4'b1101) begin
                next_state = SHIFT;
                shift_ena = 1'b1;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            if (shift_count == 3'b000) begin
                next_state = COUNTING;
            end
        end
        COUNTING: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE_ACK;
                done = 1'b1;
            end
        end
        DONE_ACK: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    endcase
end

endmodule