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
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Counter for shift cycles (4 cycles)
    reg [2:0] shift_counter; // enough bits for count up to 4

    // Sequential logic for state and pattern_shift and shift_counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;

            // Update pattern_shift only in IDLE state (shifting new bits)
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                // Do not shift pattern_shift in other states
                pattern_shift <= pattern_shift;
            end

            // Manage shift_counter
            if (state == SHIFT) begin
                // Increment counter each cycle in SHIFT
                shift_counter <= shift_counter + 3'd1;
            end else begin
                shift_counter <= 3'd0;
            end
        end
    end

    // Combinational logic for next_state
    always @(*) begin
        // Default values
        next_state = state;

        case (state)
            IDLE: begin
                // Detect pattern 1101 on pattern_shift
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // After 4 shift cycles, move to COUNT
                if (shift_counter == 3'd3) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // Wait for done_counting to go high
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack to go high, then go to IDLE
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: combinational based on state
    always @(*) begin
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (state)
            SHIFT: shift_ena = 1'b1;
            COUNT: counting = 1'b1;
            DONE: done = 1'b1;
        endcase
    end

endmodule