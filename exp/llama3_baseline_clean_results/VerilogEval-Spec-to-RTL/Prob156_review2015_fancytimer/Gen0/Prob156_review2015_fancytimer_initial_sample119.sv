module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

// States for the finite state machine
enum logic [3:0] {
    IDLE,
    DETECT_1,
    DETECT_2,
    DETECT_3,
    DETECT_4,
    SHIFT_DELAY,
    COUNTDOWN,
    WAIT_ACK
} state, next_state;

// Internal signals
logic [3:0] delay;
logic [3:0] counter;
logic [11:0] countdown;
logic [3:0] remaining_time;

// FSM state transition logic
always_comb begin
    next_state = state;

    case (state)
        IDLE: begin
            if (data == 1) next_state = DETECT_1;
            else next_state = IDLE;
        end

        DETECT_1: begin
            if (data == 1) next_state = DETECT_1;
            else next_state = DETECT_2;
        end

        DETECT_2: begin
            if (data == 0) next_state = DETECT_2;
            else next_state = DETECT_3;
        end

        DETECT_3: begin
            if (data == 1) next_state = DETECT_3;
            else next_state = DETECT_4;
        end

        DETECT_4: begin
            if (data == 1) next_state = SHIFT_DELAY;
            else next_state = IDLE;
        end

        SHIFT_DELAY: begin
            next_state = SHIFT_DELAY;
            // Shift in the next 4 bits to determine the duration to delay
            if (delay == 4'd15) next_state = COUNTDOWN;
        end

        COUNTDOWN: begin
            next_state = COUNTDOWN;
            // Count for exactly (delay + 1) * 1000 clock cycles
            if (countdown == 0) next_state = WAIT_ACK;
        end

        WAIT_ACK: begin
            next_state = WAIT_ACK;
            // Wait for the acknowledgement signal
            if (ack) next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        delay <= 0;
        counter <= 0;
        countdown <= 0;
        remaining_time <= 0;
        count <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        state <= next_state;

        case (state)
            IDLE: begin
                delay <= 0;
                counter <= 0;
                countdown <= 0;
                remaining_time <= 0;
                count <= 0;
                counting <= 0;
                done <= 0;
            end

            DETECT_1: begin
                // Do nothing
            end

            DETECT_2: begin
                // Do nothing
            end

            DETECT_3: begin
                // Do nothing
            end

            DETECT_4: begin
                // Do nothing
            end

            SHIFT_DELAY: begin
                // Shift in the next 4 bits to determine the duration to delay
                if (data) delay[3] <= 1;
                else delay[3] <= 0;

                delay[2:0] <= {delay[2:1], 1'b0};
                if (delay == 4'd15) begin
                    remaining_time <= delay;
                    countdown <= (delay + 1) * 1000;
                end
            end

            COUNTDOWN: begin
                counting <= 1;
                countdown <= countdown - 1;
                if (countdown[11:4] == 0) begin
                    remaining_time <= remaining_time - 1;
                    count <= remaining_time;
                end
            end

            WAIT_ACK: begin
                counting <= 0;
                done <= 1;
            end

            default: begin
                // Do nothing
            end
        endcase
    end
end

endmodule