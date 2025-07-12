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

// Define states
enum logic [2:0] {
    IDLE,
    SHIFTING,
    COUNTING,
    DONE_WAIT
} state, next_state;

// Define a counter for shifting
reg [1:0] shift_count;

always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if (data == 1'b1) begin // Start of pattern 1101
                next_state = IDLE;
            end else if (data == 1'b0) begin
                next_state = IDLE; // Stay in IDLE if not matching the pattern
            end else begin
                next_state = IDLE; // Handle other cases (this should not happen)
            end
            // Detect 1101 sequence and transition to SHIFTING
            // For simplicity, assume a variable pattern_det holds this condition
            // logic pattern_det;
            // if (pattern_det) next_state = SHIFTING;
            // Implement pattern detection logic here...
            logic [3:0] pattern_reg;
            always @(posedge clk) begin
                if (reset) pattern_reg <= 4'b0000;
                else pattern_reg <= {pattern_reg[2:0], data};
            end
            if (pattern_reg == 4'b1101) next_state = SHIFTING;
        end
        SHIFTING: begin
            if (shift_count == 4'd3) begin // After 4 shifts, move to COUNTING
                next_state = COUNTING;
            end else begin
                next_state = SHIFTING; // Continue shifting
            end
        end
        COUNTING: begin
            if (done_counting) begin // Counters finished, move to DONE
                next_state = DONE_WAIT;
            end else begin
                next_state = COUNTING; // Wait for counters to finish
            end
        end
        DONE_WAIT: begin
            if (ack) begin // User acknowledged, reset to IDLE
                next_state = IDLE;
            end else begin
                next_state = DONE_WAIT; // Wait for acknowledgment
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 4'b0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFTING: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                shift_count <= shift_count + 1'b1;
            end
            COUNTING: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            DONE_WAIT: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule