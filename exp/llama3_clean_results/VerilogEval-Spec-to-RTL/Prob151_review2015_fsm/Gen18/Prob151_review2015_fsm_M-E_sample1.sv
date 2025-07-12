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

// Define the top-level states
enum logic [1:0] {
    IDLE,
    PATTERN_DETECT,
    SHIFT,
    COUNT
} top_state, next_top_state;

// Define the sub-states for shifting
enum logic {
    SHIFT_INIT,
    SHIFT_COUNT
} shift_state, next_shift_state;

// Register to store the input pattern
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

// Flag to indicate if the pattern is detected
reg pattern_detected;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        top_state <= IDLE;
        shift_state <= SHIFT_INIT;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        pattern_detected <= 1'b0;
    end else begin
        case (top_state)
            IDLE: begin
                // Shift in the new data and check for the pattern '1101'
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                if (pattern_register == 4'b1101) begin
                    pattern_detected <= 1'b1;
                    top_state <= PATTERN_DETECT;
                end else begin
                    top_state <= IDLE;
                end
            end
            PATTERN_DETECT: begin
                // Transition to the SHIFT state
                top_state <= SHIFT;
                shift_state <= SHIFT_INIT;
            end
            SHIFT: begin
                // Handle the shifting process
                case (shift_state)
                    SHIFT_INIT: begin
                        // Initialize the shift counter
                        shift_counter <= 2'b00;
                        shift_state <= SHIFT_COUNT;
                    end
                    SHIFT_COUNT: begin
                        // Increment the shift counter and check if shifting is complete
                        shift_counter <= shift_counter + 1'b1;
                        if (shift_counter == 4) begin
                            shift_state <= SHIFT_INIT;
                            top_state <= COUNT;
                        end else begin
                            shift_state <= SHIFT_COUNT;
                        end
                    end
                endcase
            end
            COUNT: begin
                // Wait for the counters to finish counting
                if (done_counting) begin
                    top_state <= IDLE;
                end else begin
                    top_state <= COUNT;
                end
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (top_state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            PATTERN_DETECT: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (ack) begin
                    done <= 1'b1;
                end else begin
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule