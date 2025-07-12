module TopModule(
    input  wire       clk,
    input  wire       reset,    // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM state encoding
    typedef enum reg [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Shift register for loading delay bits MSB-first
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts from 0 to 4

    // Single down counter for total cycles: (delay+1)*1000
    reg [13:0] total_cycle_counter;

    // 10-bit subcounter counts 0..999 clock cycles for each segment
    reg [9:0] segment_cycle_counter;

    // Tracks remaining segments (delay down to 0)
    reg [3:0] segment_remaining;

    // Next state combinational logic
    always @(*) begin
        case(state)
            SEARCH: 
                if(pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;

            LOAD_DELAY:
                if(delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;

            COUNT:
                if(total_cycle_counter == 14'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                if(ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;

            default:
                next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state <= SEARCH;

            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;

            total_cycle_counter <= 14'd0;
            segment_cycle_counter <= 10'd0;
            segment_remaining <= 4'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern left, insert new data bit at LSB (MSB-first input)
                    // Newest bit at LSB; oldest at MSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    // Clear counters
                    total_cycle_counter <= 14'd0;
                    segment_cycle_counter <= 10'd0;
                    segment_remaining <= 4'd0;

                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care, use 0 for stability
                end

                LOAD_DELAY: begin
                    // Keep pattern shift fixed (pattern detected)

                    // Shift delay left, insert new bit at LSB (MSB-first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Counters not started yet
                    total_cycle_counter <= 14'd0;
                    segment_cycle_counter <= 10'd0;
                    segment_remaining <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // Hold pattern_shift and delay_reg steady

                    counting <= 1'b1;
                    done <= 1'b0;

                    if(total_cycle_counter == 14'd0) begin
                        // Timer done - no decrement
                        total_cycle_counter <= 14'd0;
                        segment_cycle_counter <= 10'd0;
                        segment_remaining <= 4'd0;
                        count <= 4'd0;
                    end else begin
                        // Decrement main total cycle counter
                        total_cycle_counter <= total_cycle_counter - 1;

                        // Increment segment cycle counter from 0 to 999
                        if(segment_cycle_counter == 10'd999) begin
                            segment_cycle_counter <= 10'd0;

                            // Decrement segments remaining if not zero
                            if(segment_remaining != 0)
                                segment_remaining <= segment_remaining - 1;

                            // Update output count to remaining segments after decrement
                            count <= segment_remaining - (segment_remaining != 0 ? 1 : 0);
                        end else begin
                            segment_cycle_counter <= segment_cycle_counter + 1;

                            // Output stable count during segment
                            count <= segment_remaining;
                        end
                    end
                end

                DONE: begin
                    // Keep all registers stable except on ack

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    total_cycle_counter <= 14'd0;
                    segment_cycle_counter <= 10'd0;
                    segment_remaining <= 4'd0;
                end

                default: begin
                    // Defensive defaults
                    state <= SEARCH;

                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    total_cycle_counter <= 14'd0;
                    segment_cycle_counter <= 10'd0;
                    segment_remaining <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize counting counters at LOAD_DELAY->COUNT transition
            if(state == LOAD_DELAY && next_state == COUNT) begin
                // Initialize counters and segments
                // total cycles = (delay + 1)*1000
                // segment_remaining counts from delay down to 0
                total_cycle_counter <= (delay_reg + 4'd1) * 14'd1000 - 14'd1; // -1 for zero-based count
                segment_cycle_counter <= 10'd0;
                segment_remaining <= delay_reg;
                count <= delay_reg;
            end
        end
    end

endmodule