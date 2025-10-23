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
    reg [9:0] cycle_counter;  // Counts up to 1000
    reg [3:0] delay_counter;  // Tracks remaining delay periods

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_shift <= 4'b0;
            delay_bits_read <= 3'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_read <= 3'b0;
                    counting <= 0;
                    done <= 0;
                end

                READ_DELAY: begin
                    if (delay_bits_read < 4) begin
                        delay_value <= {delay_value[2:0], data};
                        delay_bits_read <= delay_bits_read + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;
                end

                DONE: begin
                    if (ack) begin
                        done <= 0;
                        pattern_shift <= 4'b0;
                    end
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            IDLE: begin
                if (pattern_match)
                    next_state = READ_DELAY;
            end

            READ_DELAY: begin
                if (delay_bits_read == 4) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                if (delay_counter == 0 && cycle_counter == 999)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Counter initialization
    always @(posedge clk) begin
        if (current_state == READ_DELAY && next_state == COUNTING) begin
            cycle_counter <= 0;
            delay_counter <= delay_value;
            counting <= 1;
        end
    end

endmodule