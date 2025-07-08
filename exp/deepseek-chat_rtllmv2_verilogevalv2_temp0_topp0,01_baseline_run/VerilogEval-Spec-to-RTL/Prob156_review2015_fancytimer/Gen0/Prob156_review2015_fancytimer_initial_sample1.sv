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

    // Pattern detection registers
    reg [3:0] pattern_shift;
    wire pattern_match = (pattern_shift == 4'b1101);

    // Delay capture registers
    reg [3:0] delay_shift;
    reg [3:0] delay_value;
    reg [1:0] delay_bits_read;

    // Counters
    reg [9:0] cycle_counter;  // Counts up to 1000 (10 bits)
    reg cycle_done;
    reg [3:0] delay_counter;

    // FSM state transition
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pattern_shift <= 4'b0;
            delay_shift <= 4'b0;
            delay_bits_read <= 2'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;

            // Pattern detection shift register
            pattern_shift <= {pattern_shift[2:0], data};

            case (current_state)
                IDLE: begin
                    delay_bits_read <= 2'b0;
                    cycle_counter <= 10'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                READ_DELAY: begin
                    if (delay_bits_read < 4) begin
                        delay_shift <= {delay_shift[2:0], data};
                        delay_bits_read <= delay_bits_read + 1;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter == 4'b0) begin
                            next_state <= DONE;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        next_state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase

            // Capture delay value when reading is complete
            if (current_state == READ_DELAY && delay_bits_read == 3) begin
                delay_value <= {delay_shift[2:0], data};
                delay_counter <= {delay_shift[2:0], data};
            end
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (pattern_match) begin
                    next_state = READ_DELAY;
                end
            end
            READ_DELAY: begin
                if (delay_bits_read == 4) begin
                    next_state = COUNTING;
                end
            end
            COUNTING: begin
                if (cycle_counter == 10'd999 && delay_counter == 4'b0) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule