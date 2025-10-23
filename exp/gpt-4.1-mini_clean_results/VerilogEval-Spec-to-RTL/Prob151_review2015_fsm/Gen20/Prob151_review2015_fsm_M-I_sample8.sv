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

    // One-hot state encoding for better timing and simpler decoding
    localparam
        SEARCH0 = 7'b000_0001, // No bits matched
        SEARCH1 = 7'b000_0010, // matched '1'
        SEARCH2 = 7'b000_0100, // matched '11'
        SEARCH3 = 7'b000_1000, // matched '110'
        SHIFT   = 7'b001_0000, // shifting in 4 bits
        COUNT   = 7'b010_0000, // counting delay
        DONE    = 7'b100_0000; // done, waiting for ack

    reg [6:0] state, next_state;

    // 4-bit shift register as a counter for shift cycles, initialized to zero at reset and SEARCH states
    reg [3:0] shift_counter, next_shift_counter;

    // Pattern detection combinational logic helper
    // Detect next SEARCH state based on input data and current pattern state
    // Overlapping pattern support by carefully deciding next states

    always @(*) begin
        // Defaults
        next_state = state;
        next_shift_counter = shift_counter;

        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            SEARCH0: begin
                // pattern 1101 start detection: first bit '1'
                if (data)
                    next_state = SEARCH1;
                else
                    next_state = SEARCH0;
                next_shift_counter = 4'b0000;
            end

            SEARCH1: begin
                // matched '1', next expect '1' for 2nd bit
                if (data)
                    next_state = SEARCH2;
                else
                    next_state = SEARCH0;
                next_shift_counter = 4'b0000;
            end

            SEARCH2: begin
                // matched "11", expect '0'
                if (~data)
                    next_state = SEARCH3;
                else
                    // allow overlapping pattern by staying or going back to SEARCH2 if '1'
                    next_state = SEARCH2; // remain in SEARCH2 on '1'
                next_shift_counter = 4'b0000;
            end

            SEARCH3: begin
                // matched "110", expect '1' to complete pattern "1101"
                if (data)
                    next_state = SHIFT;
                else
                    next_state = SEARCH0;
                next_shift_counter = 4'b0000;
            end

            SHIFT: begin
                shift_ena = 1'b1;
                // Count 4 cycles using shift register - shift in '1' each cycle starting from zero
                // When MSB is 1, we've done 4 cycles
                if (shift_counter[3]) // MSB == 1 means 4 cycles done
                    next_state = COUNT;
                else
                    next_state = SHIFT;

                // shift left by 1 and insert '1' to count cycles
                next_shift_counter = {shift_counter[2:0], 1'b1};
            end

            COUNT: begin
                counting = 1'b1;
                // wait for done_counting signal to move to DONE
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
                next_shift_counter = 4'b0000;
            end

            DONE: begin
                done = 1'b1;
                // wait for ack to return to SEARCH0
                if (ack)
                    next_state = SEARCH0;
                else
                    next_state = DONE;
                next_shift_counter = 4'b0000;
            end

            default: begin
                next_state = SEARCH0;
                next_shift_counter = 4'b0000;
            end
        endcase
    end

    // Sequential logic for state and shift_counter with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH0;
            shift_counter <= 4'b0000;
        end else begin
            state <= next_state;
            shift_counter <= next_shift_counter;
        end
    end

    // Outputs are already assigned combinationally in always @(*) block

endmodule