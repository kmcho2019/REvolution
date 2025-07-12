module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
enum logic [2:0] {
    IDLE,
    PATTERN_DETECTED,
    SHIFTING,
    COUNTING_STATE,
    DONE_STATE
} state, next_state;

// Define the counter for shifting
reg [1:0] shift_counter;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Check for pattern 1101
                if (data == 1) begin
                    next_state <= PATTERN_DETECTED;
                end else begin
                    next_state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            PATTERN_DETECTED: begin
                // Check for next three bits of pattern
                if (data == 1) begin
                    next_state <= PATTERN_DETECTED;
                end else if (data == 0) begin
                    next_state <= SHIFTING;
                end else begin
                    next_state <= PATTERN_DETECTED;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFTING: begin
                // Shift in 4 more bits
                if (shift_counter < 4) begin
                    next_state <= SHIFTING;
                    shift_counter <= shift_counter + 1;
                end else begin
                    next_state <= COUNTING_STATE;
                    shift_counter <= 0;
                end
                shift_ena <= 1;
                counting <= 0;
                done <= 0;
            end
            COUNTING_STATE: begin
                // Wait for counters to finish counting
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNTING_STATE;
                end
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
            end
            DONE_STATE: begin
                // Notify user and wait for ack
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= DONE_STATE;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
            end
        endcase
    end
end

endmodule