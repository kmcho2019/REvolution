module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        SHIFT = 2'b01,
        COUNT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Counter for SHIFT state (4 cycles)
    reg [2:0] shift_counter; // 3 bits enough to count to 4

    // Sequential logic for state, pattern_shift, shift_counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;

            // Only shift pattern_shift when in IDLE state (searching for pattern)
            if (state == IDLE) begin
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                pattern_shift <= pattern_shift; // hold value in other states
            end

            // Shift counter increments only in SHIFT state
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shift_counter <= 3'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignments
        next_state = state;

        case (state)
            IDLE: begin
                // Check for pattern 1101 on pattern_shift (MSB first)
                // pattern_shift = [3:0], when equal to 4'b1101 move to SHIFT
                if (pattern_shift == 4'b1101) begin
                    next_state = SHIFT;
                end
            end

            SHIFT: begin
                // After 4 cycles (shift_counter == 3), move to COUNT
                if (shift_counter == 3'd3) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // Wait for done_counting to be high
                if (done_counting) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore machine)
    always @(*) begin
        // Default outputs
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SHIFT: begin
                shift_ena = 1'b1;
            end
            COUNT: begin
                counting = 1'b1;
            end
            DONE: begin
                done = 1'b1;
            end
        endcase
    end

endmodule