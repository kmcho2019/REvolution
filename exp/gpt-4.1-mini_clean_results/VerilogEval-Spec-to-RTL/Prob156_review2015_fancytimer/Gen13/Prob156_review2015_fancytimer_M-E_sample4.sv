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
    typedef enum reg [1:0] {
        SEARCH      = 2'd0,
        LOAD_DELAY  = 2'd1,
        COUNT       = 2'd2,
        DONE_WAIT   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101 in SEARCH state
    reg [3:0] pattern_shift;

    // Delay register to load 4-bit delay MSB first
    reg [3:0] delay_reg;

    // Bit index for loading delay bits: counts down from 3 to 0
    reg [2:0] delay_bit_index;

    // Counters for counting delay time
    reg [3:0] segment_counter;  // number of 1000-cycle segments remaining (initialized to delay+1)
    reg [9:0] cycle_counter;    // counts 0..999 cycles per segment

    // FSM next-state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: 
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;

            LOAD_DELAY:
                if (delay_bit_index == 3'd0) // last bit loaded
                    next_state = COUNT;

            COUNT:
                // when finished all segments and last cycle counted
                if (segment_counter == 4'd0 && cycle_counter == 10'd999)
                    next_state = DONE_WAIT;

            DONE_WAIT:
                if (ack)
                    next_state = SEARCH;

            default:
                next_state = SEARCH;
        endcase
    end

    // FSM sequential logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bit_index <= 3'd3;
            segment_counter <= 4'd0;
            cycle_counter <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'b0000;
                    delay_bit_index <= 3'd3;
                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Pattern shift register holds steady during delay load
                    pattern_shift <= pattern_shift;

                    // Load delay bits MSB first: delay_reg[bit_index] <= data
                    delay_reg[delay_bit_index] <= data;
                    // Decrement bit index
                    if (delay_bit_index != 0)
                        delay_bit_index <= delay_bit_index - 1'b1;
                    else
                        delay_bit_index <= 0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_counter each clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (segment_counter != 0)
                            segment_counter <= segment_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count = segment_counter - 1 (to show delay -> 0)
                    // When segment_counter = 0, count = 0 (last segment)
                    if (segment_counter == 0)
                        count <= 4'd0;
                    else
                        count <= segment_counter - 1'b1;

                end

                DONE_WAIT: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;
                    segment_counter <= segment_counter;
                    cycle_counter <= cycle_counter;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;
                end

                default: begin
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bit_index <= 3'd3;
                    segment_counter <= 4'd0;
                    cycle_counter <= 10'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // When transitioning from LOAD_DELAY to COUNT, initialize counters
            if (state == LOAD_DELAY && next_state == COUNT) begin
                // segment_counter = delay + 1, per spec
                segment_counter <= delay_reg + 4'd1;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule