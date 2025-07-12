module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input            ack
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        DELAY_LOAD = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11
    } state_t;
    reg [1:0] state, next_state;

    // For edge detection of state transitions
    reg [1:0] previous_state;

    // Pattern detection shift register (bits shifted left, new bit in LSB)
    reg [3:0] pattern_shift;

    // Delay loading register and bit count
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;

    // Counting registers
    reg [9:0] cycle_counter;  // counts 0 to 999
    reg [3:0] block_counter;  // counts down from delay+1 to 0

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end
            DELAY_LOAD: begin
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // Wait until counting done
                if ((block_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            previous_state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            block_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            previous_state <= state;
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift pattern (MSB first): shift left, new bit in LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0; // don't care
                end
                DELAY_LOAD: begin
                    // Shift delay bits MSB first: shift left, new bit in LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // Hold pattern shift stable
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0; // don't care
                end
                COUNTING: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Detect rising edge of COUNTING state
                    if (state == COUNTING && previous_state != COUNTING) begin
                        // Initialize counters at start of counting
                        block_counter <= delay_reg + 4'd1;
                        cycle_counter <= 10'd0;
                    end else begin
                        // Normal counting logic
                        if (cycle_counter == 10'd999) begin
                            cycle_counter <= 10'd0;
                            if (block_counter != 0)
                                block_counter <= block_counter - 1'b1;
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                        end
                    end

                    counting <= 1'b1;
                    done <= 1'b0;

                    // Output count = block_counter - 1 during counting, clamp to 0
                    if (block_counter == 0)
                        count <= 4'd0;
                    else
                        count <= block_counter - 1'b1;
                end
                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    block_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0; // don't care
                end
            endcase
        end
    end

endmodule