module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg  [3:0] count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    typedef enum logic [2:0] {
        PATTERN_DETECT = 3'd0,
        DELAY_LOAD     = 3'd1,
        COUNT          = 3'd2,
        DONE_WAIT_ACK  = 3'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits loaded shift register (4 bits)
    reg [3:0] delay_reg;

    // Counter for number of delay bits loaded (0..4)
    reg [2:0] delay_bits_loaded;

    // Counters for counting delay time
    reg [9:0] cycle_counter;     // counts 1000 cycles: 999 down to 0
    reg [4:0] segment_counter;   // counts delay+1 segments down to 0

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            PATTERN_DETECT: begin
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                if (segment_counter == 5'd0 && cycle_counter == 10'd0)
                    next_state = DONE_WAIT_ACK;
            end

            DONE_WAIT_ACK: begin
                if (ack)
                    next_state = PATTERN_DETECT;
            end

            default: next_state = PATTERN_DETECT;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= PATTERN_DETECT;

            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;

            cycle_counter <= 10'd0;
            segment_counter <= 5'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)

                PATTERN_DETECT: begin
                    // Shift pattern register in with new data LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay load registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Keep pattern_shift unchanged (freeze pattern detection)

                    // Shift in delay bits MSB first, i.e., shift left and append new data to LSB
                    delay_reg <= {delay_reg[2:0], data};

                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;
                end

                COUNT: begin
                    // Freeze pattern detection and delay registers
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Counting logic
                    if (cycle_counter != 10'd0) begin
                        // Count down cycles
                        cycle_counter <= cycle_counter - 1'b1;
                        segment_counter <= segment_counter;
                    end else begin
                        // cycle_counter reached 0: one 1000-cycle segment done
                        if (segment_counter != 5'd0) begin
                            segment_counter <= segment_counter - 1'b1;
                            cycle_counter <= 10'd999; // reload for next 1000 cycles
                        end else begin
                            // Counting finished, keep counters at zero
                            segment_counter <= 5'd0;
                            cycle_counter <= 10'd0;
                        end
                    end

                    // Output count is segment_counter - 1, cast down to 4 bits.
                    if (segment_counter != 5'd0)
                        count <= (segment_counter - 1'b1)[3:0];
                    else
                        count <= 4'd0;
                end

                DONE_WAIT_ACK: begin
                    // Reset pattern detection registers for next sequence
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Default reset state behavior
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

            endcase

            // Initialize counters when entering COUNT state from DELAY_LOAD
            if (state == DELAY_LOAD && next_state == COUNT) begin
                segment_counter <= delay_reg + 4'd1;  // number of 1000-cycle segments
                cycle_counter <= 10'd999;             // start cycle counter at 999 (1000 cycles)
            end
        end
    end

endmodule