module TopModule(
    input  wire       clk,
    input  wire       reset,    // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;

    // Bits loaded for delay counting (0 to 4)
    reg [2:0] bits_loaded;

    // Counters
    reg [9:0] cycle_counter;   // counts down 999..0 (1000 cycles)
    reg [3:0] segment_counter; // counts down number of 1000-cycle segments (delay+1 .. 0)

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end

            LOAD_DELAY: begin
                if (bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            COUNT: begin
                // Transition to WAIT_ACK only after full counting done
                if ((segment_counter == 4'd0) && (cycle_counter == 10'd0))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;
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
            bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in new data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay load info and counters
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Do not update pattern_shift to freeze pattern detection
                    pattern_shift <= pattern_shift;

                    // Shift delay bits MSB first: shift left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};

                    bits_loaded <= bits_loaded + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    // Freeze pattern_shift and delay_reg during counting
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle entering COUNT, counters are initialized below

                    // Counting logic:
                    if ((segment_counter == 4'd0) && (cycle_counter == 10'd0)) begin
                        // Done counting, hold counters at zero
                        cycle_counter <= 10'd0;
                        segment_counter <= 4'd0;
                    end else if (cycle_counter == 10'd0) begin
                        // Completed one 1000-cycle segment: start next if any remain
                        segment_counter <= segment_counter - 1'b1;
                        cycle_counter <= 10'd999; // reload for next segment
                    end else begin
                        // Normal counting: decrement cycle_counter
                        cycle_counter <= cycle_counter - 1'b1;
                    end

                    // Output count = segment_counter - 1 during counting; zero if segment_counter=0
                    if (segment_counter != 4'd0)
                        count <= segment_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    // Reset pattern_shift to zero to prepare for next pattern search
                    pattern_shift <= 4'b0000;

                    // Keep delay_reg and bits_loaded as is (optional clear)
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Safe fallback to reset state
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize counters on transition from LOAD_DELAY to COUNT
            if ((state == LOAD_DELAY) && (next_state == COUNT)) begin
                segment_counter <= delay_reg + 4'd1; // number of 1000-cycle segments
                cycle_counter <= 10'd999;            // start counting 1000 cycles (0..999)
            end
        end
    end

endmodule