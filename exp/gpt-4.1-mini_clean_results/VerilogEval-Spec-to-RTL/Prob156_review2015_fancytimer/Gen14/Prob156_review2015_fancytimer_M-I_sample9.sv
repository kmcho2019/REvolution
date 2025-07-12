module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    typedef enum reg [2:0] {
        IDLE        = 3'd0,
        LOAD_DELAY  = 3'd1,
        SETUP_COUNT = 3'd2,
        COUNTING    = 3'd3,
        DONE        = 3'd4
    } state_t;

    reg [2:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 bits delay input
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for timing
    reg [3:0] segment_count;     // counts down from delay+1 to 0
    reg [9:0] cycle_counter;     // counts 0..999 (1000 cycles per segment)

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = SETUP_COUNT;
            end
            SETUP_COUNT: begin
                next_state = COUNTING;
            end
            COUNTING: begin
                // Transition to DONE when all segments done after full 1000 cycle block
                if ((segment_count == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;

            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;

            segment_count <= 4'd0;
            cycle_counter <= 10'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern_shift left by 1, insert new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters and outputs
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left by 1, insert new bit at LSB (MSB-first input)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Freeze pattern_shift to avoid false detections during delay loading
                    pattern_shift <= pattern_shift;

                    segment_count <= segment_count;
                    cycle_counter <= cycle_counter;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                SETUP_COUNT: begin
                    // Initialize segment_count to delay + 1 (total number of 1000-cycle segments)
                    segment_count <= delay_reg + 1'b1;
                    cycle_counter <= 10'd0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count = segment_count - 1, which equals delay initially
                    count <= delay_reg;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (segment_count != 0)
                            segment_count <= segment_count - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        segment_count <= segment_count; // hold stable during segment
                    end

                    // Output count = segment_count - 1 if segment_count > 0, else 0
                    if (segment_count != 0)
                        count <= segment_count - 1'b1;
                    else
                        count <= 4'd0;
                end

                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    segment_count <= segment_count;
                    cycle_counter <= cycle_counter;

                    counting <= 1'b0;
                    done <= 1'b1;

                    // count output can be 0 in DONE state
                    count <= 4'd0;
                end

                default: begin
                    // Safe defaults
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

endmodule