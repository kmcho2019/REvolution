module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define states
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_STATE,
    RESET_STATE
} state, next_state;

// Initialize shift counter
reg [1:0] shift_counter;

// Initialize pattern detector
reg [3:0] pattern_detector;

// FSM logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_counter <= 0;
        pattern_detector <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Check for start pattern (1101)
                pattern_detector <= {pattern_detector[2:0], data};
                if (pattern_detector == 4'b1101) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                // Shift in 4 more bits
                shift_ena <= 1;
                shift_counter <= shift_counter + 1;
                if (shift_counter == 4) begin
                    next_state <= COUNT;
                    shift_ena <= 0;
                end else begin
                    next_state <= SHIFT;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                // Wait for counters to finish counting
                counting <= 1;
                if (done_counting) begin
                    next_state <= DONE_STATE;
                end else begin
                    next_state <= COUNT;
                end
                shift_ena <= 0;
                done <= 0;
            end
            DONE_STATE: begin
                // Notify user and wait for acknowledgement
                done <= 1;
                if (ack) begin
                    next_state <= IDLE;
                    done <= 0;
                end else begin
                    next_state <= DONE_STATE;
                end
                shift_ena <= 0;
                counting <= 0;
            end
            default: begin
                next_state <= IDLE;
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule