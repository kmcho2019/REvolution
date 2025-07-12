module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// Define the states
enum logic [3:0] {IDLE, DETECT_1101, SHIFT_DELAY, COUNT, DONE} state, next_state;

// Register to store the delay
logic [3:0] delay;

// Counter to count clock cycles
logic [19:0] counter;

// Register to store the remaining time
logic [3:0] remaining_time;

// Internal signal to indicate if the pattern 1101 is detected
logic pattern_detected;

// Internal signal to shift in the next 4 bits
logic [3:0] shift_counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 4'b0;
        counter <= 20'b0;
        remaining_time <= 4'b0;
        count <= 4'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    state <= DETECT_1101;
                    shift_counter <= 4'b0;
                end
            end
            DETECT_1101: begin
                if (shift_counter == 4'b1000) begin
                    state <= COUNT;
                    counter <= 20'b0;
                    remaining_time <= delay;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            COUNT: begin
                if (counter == (delay + 1'b1) * 1000) begin
                    state <= DONE;
                end else begin
                    counter <= counter + 1'b1;
                    if (counter % 1000 == 20'b0) begin
                        remaining_time <= remaining_time - 1'b1;
                    end
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase

        // Detect the pattern 1101
        if (data == 1'b1 && state == IDLE) begin
            pattern_detected <= 1'b1;
        end else if (state != IDLE) begin
            pattern_detected <= 1'b0;
        end

        // Shift in the next 4 bits
        if (state == DETECT_1101) begin
            if (shift_counter[0] == 1'b1) begin
                delay[3] <= data;
            end else if (shift_counter[1] == 1'b1) begin
                delay[2] <= data;
            end else if (shift_counter[2] == 1'b1) begin
                delay[1] <= data;
            end else if (shift_counter[3] == 1'b1) begin
                delay[0] <= data;
            end
        end

        // Update the count output
        if (state == COUNT) begin
            count <= remaining_time;
            counting <= 1'b1;
        end else begin
            counting <= 1'b0;
        end

        // Update the done output
        if (state == DONE) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule