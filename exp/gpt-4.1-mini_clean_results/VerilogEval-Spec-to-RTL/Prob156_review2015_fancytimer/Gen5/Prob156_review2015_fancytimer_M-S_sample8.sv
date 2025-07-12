module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  [3:0] count,
    output reg  counting,
    output reg  done,
    input  wire ack
);

    // States
    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNTING   = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern shift register for detecting 1101 in IDLE
    reg [3:0] pattern_shift;

    // Delay register and bit counter for loading delay bits
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Counters for COUNTING state
    reg [9:0] micro_counter; // counts 0..999
    reg [3:0] step_counter;  // counts down from delay_reg to 0

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_loaded <= 3'd0;
            micro_counter <= 10'd0;
            step_counter <= 4'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern register
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear outputs and counters
                    delay_bits_loaded <= 3'd0;
                    micro_counter <= 10'd0;
                    step_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    pattern_shift <= pattern_shift; // Hold pattern_shift
                    micro_counter <= 10'd0;
                    step_counter <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // micro_counter counts 0..999
                    if (micro_counter == 10'd999) begin
                        micro_counter <= 10'd0;
                        if (step_counter != 0)
                            step_counter <= step_counter - 1'b1;
                    end else begin
                        micro_counter <= micro_counter + 1'b1;
                    end

                    // count output is current step remaining stable for 1000 cycles:
                    // when micro_counter increments, count stays until micro_counter hits 999 then step_counter decrements
                    count <= step_counter;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    // Hold registers (not strictly necessary)
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= 3'd0;
                    micro_counter <= 10'd0;
                    step_counter <= 4'd0;
                end

                default: begin
                    // Defensive default to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = IDLE;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
                else
                    next_state = DELAY_LOAD;
            end

            COUNTING: begin
                // When step_counter == 0 and micro_counter == 999, counting is done
                if ((step_counter == 0) && (micro_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Load step_counter with delay_reg at the start of COUNTING state
    // Detect rising edge of COUNTING state to load step_counter = delay + 1
    reg counting_rising;
    always @(posedge clk) begin
        if (reset) begin
            counting_rising <= 1'b0;
        end else begin
            counting_rising <= (next_state == COUNTING) && (state != COUNTING);
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            step_counter <= 4'd0;
        end else if (counting_rising) begin
            // step_counter counts steps from delay down to 0, so total steps = delay+1
            step_counter <= delay_reg + 1'b1;
            micro_counter <= 10'd0;
        end
    end

endmodule