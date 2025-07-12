module TopModule (
    input  wire       clk,
    input  wire       reset,  // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    // We'll keep newest bit at MSB, oldest at LSB.
    // So shift right and insert new bit at MSB.
    reg [3:0] pattern_shift;

    // Delay register (4 bits) loaded MSB-first same way
    reg [3:0] delay;
    reg [2:0] delay_bits_loaded; // counts how many bits loaded (0 to 4)

    // Counting registers
    reg [9:0] cycle_counter;    // counts down 999 to 0 per segment
    reg [3:0] segment_counter;  // counts down delay to 0 segments remaining

    // Pattern found signal combinational
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_found)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // When counting done, move to WAIT_ACK
                if ((segment_counter == 0) && (cycle_counter == 0))
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic block: all registers update here
    always @(posedge clk) begin
        if (reset) begin
            // Reset all regs
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern register right, insert data at MSB (newest bit)
                    pattern_shift <= {data, pattern_shift[3:1]};
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                LOAD_DELAY: begin
                    // Shift delay register right, insert data at MSB (MSB-first)
                    delay <= {data, delay[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold pattern_shift stable
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold stable
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 0) begin
                        // Finished one 1000-cycle segment

                        if (segment_counter == 0) begin
                            // Counting done; count output can be 0
                            count <= 4'd0;
                            counting <= 1'b0;
                            cycle_counter <= 10'd0;
                        end else begin
                            // Start next 1000 cycle segment
                            cycle_counter <= 10'd999;
                            segment_counter <= segment_counter - 1'b1;
                            count <= segment_counter - 1'b1; // count shows segments left - 1
                        end
                    end else begin
                        // Continue counting current 1000-cycle segment
                        cycle_counter <= cycle_counter - 1'b1;
                        // count output remains constant for entire 1000 cycle segment
                        count <= segment_counter;
                    end
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'b0000;
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                default: begin
                    // Default safe reset values
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase

            // Detect transition from previous state to COUNT to initialize counters
            // We do it after case to overwrite any counters at cycle start of COUNT state
            if (state != COUNT && next_state == COUNT) begin
                // Initialize counting counters
                segment_counter <= delay; // segments remaining = delay down to 0
                cycle_counter <= 10'd999; // count cycles 0..999 = 1000 cycles total
                count <= delay; // initial count output = delay
            end
        end
    end

endmodule