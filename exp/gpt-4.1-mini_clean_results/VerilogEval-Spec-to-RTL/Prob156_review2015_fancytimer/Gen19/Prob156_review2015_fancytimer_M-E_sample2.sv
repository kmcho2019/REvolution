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
    localparam IDLE         = 3'd0;
    localparam PATTERN_MATCH= 3'd1;
    localparam LOAD_DELAY   = 3'd2;
    localparam COUNT        = 3'd3;
    localparam WAIT_ACK     = 3'd4;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits, newest bit at LSB)
    reg [3:0] pattern_shift;

    // Delay register: 4 bits delay value, shift in MSB first
    reg [3:0] delay;

    // Load delay bits count (0 to 4)
    reg [2:0] load_bits;

    // Master counter counts total cycles remaining
    reg [15:0] master_counter;  // 16 bits enough for (15*1000=15000 max)

    // Segment counter shows current remaining 1000-cycle segments (delay down to 0)
    reg [3:0] segment_counter;

    // Pattern 1101 is bits 3..0 = 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (pattern_detected) ? PATTERN_MATCH : IDLE;
            PATTERN_MATCH:
                next_state = LOAD_DELAY;
            LOAD_DELAY:
                next_state = (load_bits == 3'd4) ? COUNT : LOAD_DELAY;
            COUNT:
                next_state = (master_counter == 16'd0) ? WAIT_ACK : COUNT;
            WAIT_ACK:
                next_state = (ack) ? IDLE : WAIT_ACK;
            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            load_bits <= 3'd0;
            master_counter <= 16'd0;
            segment_counter <= 4'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern_shift left by 1, insert new data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    delay <= 4'b0000;
                    load_bits <= 3'd0;
                    master_counter <= 16'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                PATTERN_MATCH: begin
                    // Hold pattern_shift (no change)
                    pattern_shift <= pattern_shift;

                    delay <= 4'b0000;
                    load_bits <= 3'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay left by 1, insert new data bit at LSB (MSB first)
                    delay <= {delay[2:0], data};
                    load_bits <= load_bits + 1'b1;

                    // Hold pattern_shift
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // pattern_shift and delay remain stable
                    pattern_shift <= pattern_shift;
                    delay <= delay;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (master_counter == 16'd0) begin
                        // Counting done
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'd0;
                        segment_counter <= 4'd0;
                    end else begin
                        master_counter <= master_counter - 1'b1;

                        // Calculate current segment: divide remaining master_counter by 1000
                        // Note: segment_counter = master_counter / 1000
                        // To avoid division in hardware, decrement segment_counter every 1000 cycles
                        // Implement a sub-counter counting cycles 0..999 for each segment

                        // We'll implement this with a 10-bit cycle_counter (counts 0..999)
                        // so need to add it here:

                        // We'll split master_counter update and counting logic below
                    end

                    // We defer cycle_counter and segment_counter update to below (outside case)
                end

                WAIT_ACK: begin
                    // Hold everything stable, waiting for ack
                    pattern_shift <= pattern_shift;
                    delay <= delay;
                    load_bits <= load_bits;
                    master_counter <= master_counter;
                    segment_counter <= segment_counter;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Default reset fallback
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay <= 4'b0000;
                    load_bits <= 3'd0;
                    master_counter <= 16'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Special initialization of counters when entering COUNT state
            if (state != COUNT && next_state == COUNT) begin
                // Initialize counters when moving into COUNT
                // master_counter = (delay + 1)*1000
                // segment_counter = delay (segments remaining)
                master_counter <= (delay + 1'b1) * 16'd1000;
                segment_counter <= delay;
                count <= delay;
            end

            // In COUNT state, implement cycle segmentation counting
            // Use a 10-bit cycle_counter to count from 999 down to 0
            // On cycle_counter == 0 decrement segment_counter

            // We define cycle_counter outside case for clarity
        end
    end

    // Separate cycle_counter for counting 1000 cycles per segment
    reg [9:0] cycle_counter;

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
        end else if (state == COUNT) begin
            if (master_counter == 16'd0) begin
                cycle_counter <= 10'd0;
            end else if (cycle_counter == 10'd0) begin
                cycle_counter <= 10'd999;
            end else begin
                cycle_counter <= cycle_counter - 1'b1;
            end
        end else begin
            cycle_counter <= 10'd0;
        end
    end

    // Update segment_counter and count on cycle_counter transitions
    always @(posedge clk) begin
        if (reset) begin
            segment_counter <= 4'd0;
            count <= 4'd0;
        end else if (state == COUNT) begin
            if (master_counter == 16'd0) begin
                segment_counter <= 4'd0;
                count <= 4'd0;
            end else if (cycle_counter == 10'd0) begin
                // At end of 1000-cycle segment, decrement segment_counter
                if (segment_counter != 4'd0) begin
                    segment_counter <= segment_counter - 1'b1;
                    count <= segment_counter - 1'b1;
                end else begin
                    // segment_counter already zero, count remains 0
                    segment_counter <= 4'd0;
                    count <= 4'd0;
                end
            end
            // count remains stable during counting cycles
        end else if (state == IDLE || state == WAIT_ACK) begin
            count <= 4'd0;
            segment_counter <= 4'd0;
        end
    end

endmodule