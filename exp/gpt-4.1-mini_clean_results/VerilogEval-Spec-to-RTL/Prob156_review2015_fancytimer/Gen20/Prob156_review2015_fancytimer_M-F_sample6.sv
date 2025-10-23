module TopModule(
    input  wire       clk,
    input  wire       reset,    // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    localparam IDLE       = 3'd0;
    localparam LOAD_DELAY = 3'd1;
    localparam COUNT      = 3'd2;
    localparam WAIT_ACK   = 3'd3;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits, newest bit at LSB)
    reg [3:0] pattern_shift;

    // Delay register: 4 bits delay value, shift in MSB first
    reg [3:0] delay;

    // Counter for number of bits loaded in LOAD_DELAY (0..4)
    reg [2:0] load_bits;

    // Counters for timing
    reg [15:0] master_counter;  // counts total clock cycles remaining
    reg [9:0]  cycle_counter;   // counts 0..999 cycles within each segment
    reg [3:0]  segment_counter; // counts remaining 1000-cycle segments

    wire pattern_detected = (pattern_shift == 4'b1101);

    // FSM next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if(pattern_detected)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end

            LOAD_DELAY: begin
                if(load_bits == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            COUNT: begin
                if(master_counter == 16'd0)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if(ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: FSM, pattern detection, delay loading, counting, and outputs
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            load_bits <= 3'd0;

            master_counter <= 16'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in new data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    delay <= 4'b0000;
                    load_bits <= 3'd0;

                    master_counter <= 16'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // In LOAD_DELAY, shift in delay bits MSB first:
                    // delay <= {delay[2:0], data}
                    delay <= {delay[2:0], data};
                    load_bits <= load_bits + 1'b1;

                    // pattern_shift remains unchanged, no new pattern detection
                    // Outputs not asserted
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // Counting state, decrement counters
                    counting <= 1'b1;
                    done <= 1'b0;

                    if(master_counter != 16'd0) begin
                        master_counter <= master_counter - 1'b1;

                        // Manage cycle_counter: counts down 999..0 every clock
                        if(cycle_counter == 10'd0) begin
                            cycle_counter <= 10'd999;

                            // Decrement segment_counter if > 0
                            if(segment_counter != 4'd0) begin
                                segment_counter <= segment_counter - 1'b1;
                            end
                        end else begin
                            cycle_counter <= cycle_counter - 1'b1;
                        end
                    end else begin
                        // master_counter is zero, counting done
                        counting <= 1'b0;
                        done <= 1'b1;

                        count <= 4'd0;
                    end

                    // Output count = current segment_counter while counting
                    // segment_counter goes from delay down to 0 during counting
                    count <= segment_counter;
                end

                WAIT_ACK: begin
                    // Wait for ack, done asserted
                    done <= 1'b1;
                    counting <= 1'b0;

                    // Outputs don't care except done, count zeroed for convenience
                    count <= 4'd0;

                    // Keep pattern_shift, delay, counters stable (optional)
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    load_bits <= load_bits;
                    master_counter <= master_counter;
                    cycle_counter <= cycle_counter;
                    segment_counter <= segment_counter;
                end

                default: begin
                    // Reset fallback
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    load_bits <= 3'd0;

                    master_counter <= 16'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // On state transition: if entering COUNT, initialize counters
            if(state != COUNT && next_state == COUNT) begin
                // Initialize counters for counting phase
                // Master counter counts (delay + 1)*1000 cycles
                master_counter <= (delay + 1'b1) * 16'd1000;
                segment_counter <= delay;
                cycle_counter <= 10'd999;

                // count and outputs will be updated on next clock cycle
            end
        end
    end

endmodule