module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// States for the FSM
enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
} state, next_state;

// Registers to store the delay value and the remaining time
reg [3:0] delay;
reg [3:0] remaining_time;
reg [15:0] counter;

// Shift register for the delay value
reg [3:0] shift_reg;

// Signal to indicate if the 1101 pattern has been detected
reg pattern_detected;

// FSM logic
always @(*) begin
    case(state)
        IDLE: begin
            if (pattern_detected) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_reg == 4'b1111) begin
                next_state = COUNTING;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNTING: begin
            if (counter == 0) begin
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
    endcase
end

// Update state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detected <= 0;
        shift_reg <= 0;
        delay <= 0;
        remaining_time <= 0;
        counter <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == IDLE) begin
            // Check for the 1101 pattern
            if (data == 1) begin
                pattern_detected <= 1;
            end else if (pattern_detected == 1 && data == 0) begin
                pattern_detected <= 0;
            end
        end else if (state == SHIFT) begin
            // Shift in the delay value
            shift_reg <= {data, shift_reg[3:1]};
            if (shift_reg == 4'b1111) begin
                delay <= {data, shift_reg[3:1]};
                remaining_time <= delay;
            end
        end else if (state == COUNTING) begin
            // Decrement the counter and the remaining time
            counter <= counter - 1;
            if (counter == 0) begin
                remaining_time <= remaining_time - 1;
                counter <= (remaining_time + 1) * 1000 - 1;
            end
            counting <= 1;
            count <= remaining_time;
        end else if (state == DONE) begin
            // Wait for the ack signal
            done <= 1;
            if (ack) begin
                pattern_detected <= 0;
                shift_reg <= 0;
                delay <= 0;
                remaining_time <= 0;
                counter <= 0;
                counting <= 0;
                done <= 0;
            end
        end
    end
end

endmodule