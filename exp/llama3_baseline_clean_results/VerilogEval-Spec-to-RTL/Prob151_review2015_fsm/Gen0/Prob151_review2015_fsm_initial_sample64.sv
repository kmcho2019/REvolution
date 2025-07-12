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

// Define the states of the FSM
enum logic [2:0] {
    IDLE,       // Search for pattern 1101
    SHIFT,      // Shift in the duration
    COUNT,      // Count down
    WAIT_COUNT, // Wait for counters to finish
    NOTIFY,     // Notify the user
    ACK         // Wait for acknowledgment
} state, next_state;

// Current state and next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (data == 1'b1 && prev_data == 1'b1 && prev_prev_data == 1'b0 && prev_prev_prev_data == 1'b1) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            if (shift_counter == 4'd4) begin
                next_state = COUNT;
            end else begin
                next_state = SHIFT;
            end
        end
        COUNT: begin
            next_state = COUNT; // handled in sequential logic
        end
        WAIT_COUNT: begin
            if (done_counting) begin
                next_state = NOTIFY;
            end else begin
                next_state = WAIT_COUNT;
            end
        end
        NOTIFY: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = NOTIFY;
            end
        end
        ACK: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = ACK;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Previous data and counters
logic [2:0] prev_prev_prev_data, prev_prev_data, prev_data;
logic [1:0] shift_counter;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        prev_prev_prev_data <= 1'b0;
        prev_prev_data <= 1'b0;
        prev_data <= 1'b0;
        shift_counter <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_ena <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                prev_prev_prev_data <= prev_prev_data;
                prev_prev_data <= prev_data;
                prev_data <= data;
            end
            SHIFT: begin
                prev_prev_prev_data <= prev_prev_data;
                prev_prev_data <= prev_data;
                prev_data <= data;
                if (shift_counter == 4'd3) begin
                    shift_counter <= 4'd4;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                state <= WAIT_COUNT;
            end
            WAIT_COUNT: begin
                counting <= 1'b1;
            end
            NOTIFY: begin
                done <= 1'b1;
            end
            ACK: begin
                done <= 1'b1;
            end
            default: ;
        endcase
        state <= next_state;
        if (state == SHIFT) begin
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
        if (state == IDLE || state == SHIFT || state == NOTIFY || state == ACK) begin
            counting <= 1'b0;
        end
        if (state == IDLE || state == SHIFT || state == COUNT || state == WAIT_COUNT || state == ACK) begin
            done <= 1'b0;
        end
    end
end

endmodule