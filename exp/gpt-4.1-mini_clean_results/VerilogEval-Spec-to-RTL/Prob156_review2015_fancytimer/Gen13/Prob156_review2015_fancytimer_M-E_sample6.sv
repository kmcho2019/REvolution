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

    // Combinational next state logic
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
                // When last segment counted (segment_count==0) and 1000 cycles done
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
            count <= 4'bxxxx;  // don't care when not counting
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in new data bit into pattern_shift (shift left, insert data at LSB)
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care in idle
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first: shift left and insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    pattern_shift <= pattern_shift; // Hold pattern_shift constant
                    segment_count <= segment_count;
                    cycle_counter <= cycle_counter;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care before counting
                end

                SETUP_COUNT: begin
                    // Load segment_count with delay + 1
                    segment_count <= delay_reg + 1'b1;
                    cycle_counter <= 10'd0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_reg + 1'b1;  // initial count output
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_counter every clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement segment_count if > 0
                        if (segment_count != 0)
                            segment_count <= segment_count - 1'b1;
                        // else remain zero
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        segment_count <= segment_count; // hold stable until next segment
                    end

                    // Output current segment_count as count
                    count <= segment_count;
                end

                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    segment_count <= segment_count;
                    cycle_counter <= cycle_counter;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care when done
                end

                default: begin
                    // Default safe state
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    segment_count <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

endmodule