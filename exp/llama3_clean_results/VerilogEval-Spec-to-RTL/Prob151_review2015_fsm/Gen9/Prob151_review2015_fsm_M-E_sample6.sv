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

// Define the states of the state machine
enum logic [1:0] {
    IDLE,
    PATTERN_DETECT,
    SHIFT_DATA,
    COUNTDOWN
} current_state, next_state;

// Register to store the input pattern
reg [3:0] pattern_register;

// Counter for shifting
reg [1:0] shift_counter;

// Counter for duration
reg [3:0] duration_counter;

always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        pattern_register <= 4'b0000;
        shift_counter <= 2'b00;
        duration_counter <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (current_state)
            IDLE: begin
                pattern_register[3:1] <= pattern_register[2:0];
                pattern_register[0] <= data;
                if (pattern_register == 4'b1101) begin
                    next_state <= PATTERN_DETECT;
                end else begin
                    next_state <= IDLE;
                end
            end
            PATTERN_DETECT: begin
                shift_counter <= shift_counter + 1'b1;
                if (shift_counter == 4) begin
                    next_state <= SHIFT_DATA;
                end else begin
                    next_state <= PATTERN_DETECT;
                end
                duration_counter[3:1] <= duration_counter[2:0];
                duration_counter[0] <= data;
            end
            SHIFT_DATA: begin
                if (done_counting) begin
                    next_state <= COUNTDOWN;
                end else begin
                    next_state <= SHIFT_DATA;
                end
            end
            COUNTDOWN: begin
                if (ack) begin
                    next_state <= IDLE;
                end else begin
                    next_state <= COUNTDOWN;
                end
            end
        endcase

        // Update the current state
        current_state <= next_state;

        // Output logic
        case (current_state)
            IDLE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            PATTERN_DETECT: begin
                shift_ena <= 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT_DATA: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                done <= 1'b0;
            end
            COUNTDOWN: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
            end
        endcase
    end
end

endmodule