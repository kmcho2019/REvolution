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

    // Number of delay bits loaded (0 to 4)
    reg [2:0] bits_loaded;

    // Counters
    reg [9:0] cycle_counter;   // counts down from 999 to 0 (1000 cycles)
    reg [4:0] segment_counter; // counts number of segments remaining (delay+1 down to 0)
                               // 5 bits to avoid overflow for delay+1 (max 16)

    // Next state logic
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
                // When both counters zero, counting done
                if ((segment_counter == 5'd0) && (cycle_counter == 10'd0))
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
            // Reset all state and registers
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data LSB every clock for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading info and counters
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Freeze pattern detection register to avoid false detection during delay loading
                    pattern_shift <= pattern_shift;

                    // Shift delay register left and insert new bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};

                    bits_loaded <= bits_loaded + 1'b1;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;
                end

                COUNT: begin
                    // Pattern detection inactive
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter != 10'd0) begin
                        cycle_counter <= cycle_counter - 1'b1;
                        segment_counter <= segment_counter;
                    end else begin
                        // cycle_counter is zero now, meaning this 1000-cycle segment is complete
                        if (segment_counter != 5'd0) begin
                            segment_counter <= segment_counter - 1'b1;
                            cycle_counter <= 10'd999; // Reload for next 1000 cycles
                        end else begin
                            // Counting finished, keep counters at zero
                            segment_counter <= 5'd0;
                            cycle_counter <= 10'd0;
                        end
                    end

                    // Output count = segment_counter - 1 (4 bits)
                    // To keep count within 4 bits, truncate segment_counter to 4 bits.
                    // During counting, segment_counter>=1; when zero counting done
                    if (segment_counter != 5'd0)
                        count <= (segment_counter - 1'b1)[3:0];
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    // Clear pattern detection for next run
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Safe defaults
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize counters when transitioning from LOAD_DELAY to COUNT
            if ((state == LOAD_DELAY) && (next_state == COUNT)) begin
                // Initialize segment_counter and cycle_counter exactly once on transition
                segment_counter <= delay_reg + 4'd1; // number of 1000-cycle segments (delay+1)
                cycle_counter <= 10'd999;            // start first 1000-cycle segment counter
            end
        end
    end

endmodule