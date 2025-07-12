module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        READ_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection
    reg [3:0] pattern_shift;
    wire pattern_match = (pattern_shift == 4'b1101);

    // Delay value storage
    reg [3:0] delay_value;
    reg [2:0] delay_bits_read;

    // Counters
    reg [9:0] cycle_counter;  // Counts up to 999 (1000 cycles)
    reg [3:0] delay_counter;  // Tracks remaining delay periods

    // FSM state transition and sequential logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_shift <= 4'b0;
            delay_bits_read <= 3'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            cycle_counter <= 0;
            delay_counter <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    pattern_shift <= {pattern_shift[2:0], data};
                    if (pattern_match) begin
                        next_state <= READ_DELAY;
                        delay_bits_read <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                READ_DELAY: begin
                    if (delay_bits_read < 4) begin
                        delay_value <= {delay_value[2:0], data};
                        delay_bits_read <= delay_bits_read + 1;
                    end
                    if (delay_bits_read == 3) begin  // After reading 4 bits
                        next_state <= COUNTING;
                        cycle_counter <= 0;
                        delay_counter <= delay_value;  // Initialize with full delay
                        counting <= 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            next_state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;  // Show current remaining delay
                end

                DONE: begin
                    if (ack) begin
                        next_state <= IDLE;
                        done <= 0;
                        pattern_shift <= 4'b0;
                    end
                end

                default: next_state <= IDLE;
            endcase
            current_state <= next_state;
        end
    end

endmodule