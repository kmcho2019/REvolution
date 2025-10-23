module TopModule(
    input           clk,
    input           reset,
    input           data,
    input           done_counting,
    input           ack,
    output          shift_ena,
    output          counting,
    output          done
);

// Define the states
typedef enum logic [1:0] {
    IDLE,
    SHIFT,
    COUNT,
    DONE_WAIT
} state_t;

state_t state, next_state;
logic [3:0] shift_counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_counter <= 0;
    end else begin
        state <= next_state;
        if (state == SHIFT && shift_ena) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 0;
        end
    end
end

always_comb begin
    shift_ena = 1'b0;
    counting = 1'b0;
    done = 1'b0;
    next_state = state;

    case (state)
        IDLE: begin
            // Search for the pattern 1101
            if (data == 1'b1) begin
                // Start shifting
                next_state = SHIFT;
            end
        end
        SHIFT: begin
            shift_ena = 1'b1;
            if (shift_counter == 4) begin
                next_state = COUNT;
            end
        end
        COUNT: begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = DONE_WAIT;
            end
        end
        DONE_WAIT: begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule