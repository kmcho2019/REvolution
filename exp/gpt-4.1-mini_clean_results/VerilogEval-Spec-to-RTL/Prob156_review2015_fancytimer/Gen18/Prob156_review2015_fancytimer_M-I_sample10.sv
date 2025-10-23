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

    // Bits loaded for delay counting
    reg [2:0] bits_loaded;

    // Counters
    reg [9:0] cycle_counter;   // counts down from 999 to 0 (1000 cycles)
    reg [3:0] segment_counter; // counts number of segments remaining (delay+1 down to 0)

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;

            LOAD_DELAY:
                if (bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;

            COUNT:
                // When both counters zero, counting done
                if ((segment_counter == 4'd0) && (cycle_counter == 10'd0))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;

            WAIT_ACK:
                if (ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;

            default:
                next_state = IDLE;
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
                    // Shift in new bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading info and counters
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Keep pattern_shift steady (no update) to avoid false detection
                    pattern_shift <= pattern_shift;

                    // Shift delay register left by 1, insert new bit at LSB (MSB first)
                    // So first loaded bit goes into MSB, last into LSB
                    delay_reg <= {delay_reg[2:0], data};

                    bits_loaded <= bits_loaded + 1'b1;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                COUNT: begin
                    // Pattern detection disabled during counting
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Decrement cycle counter if not zero
                    if (cycle_counter != 10'd0) begin
                        cycle_counter <= cycle_counter - 1'b1;
                        segment_counter <= segment_counter; // no change this cycle
                    end else begin
                        // cycle_counter is zero, meaning segment finished this cycle
                        if (segment_counter != 4'd0) begin
                            // Start next 1000 cycle segment
                            cycle_counter <= 10'd999;
                            segment_counter <= segment_counter - 1'b1;
                        end else begin
                            // All segments done, keep counters at zero
                            cycle_counter <= 10'd0;
                            segment_counter <= 4'd0;
                        end
                    end

                    // Output count = segment_counter - 1 during counting, zero if segment_counter=0
                    // We output the current remaining segment minus 1, showing delay for first 1000 cycles, delay-1 for next, etc.
                    if (segment_counter != 4'd0)
                        count <= segment_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    // Reset pattern_shift to start fresh next time
                    pattern_shift <= 4'b0000;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Safe default fallback
                    state <= IDLE;
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

            // Initialize counters when transitioning from LOAD_DELAY to COUNT
            if ((state == LOAD_DELAY) && (next_state == COUNT)) begin
                // delay_reg is loaded MSB first correctly by shifting left
                segment_counter <= delay_reg + 4'd1; // number of 1000-cycle segments
                cycle_counter <= 10'd999;            // start first segment count (1000 cycles)
            end
        end
    end

endmodule