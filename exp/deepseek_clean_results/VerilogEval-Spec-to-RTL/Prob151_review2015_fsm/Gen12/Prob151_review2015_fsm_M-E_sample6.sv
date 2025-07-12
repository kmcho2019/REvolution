module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        WAIT,
        SHIFT,
        COUNT,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection registers
    reg [2:0] history;
    wire pattern_detected = (history == 3'b110) && (data == 1'b1);

    // Shift counter (counts down from 3 to 0)
    reg [1:0] shift_counter;

    // History register update
    always @(posedge clk) begin
        if (reset) begin
            history <= 3'b0;
        end else begin
            history <= {history[1:0], data};
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'd3;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT) begin
                shift_counter <= shift_counter - 1'b1;
            end else if (current_state == WAIT) begin
                shift_counter <= 2'd3;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = pattern_detected ? WAIT : IDLE;
            WAIT:  next_state = SHIFT;
            SHIFT: next_state = (shift_counter == 2'd0) ? COUNT : SHIFT;
            COUNT: next_state = done_counting ? DONE : COUNT;
            DONE:  next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (current_state == SHIFT);
        counting = (current_state == COUNT);
        done = (current_state == DONE);
    end

endmodule