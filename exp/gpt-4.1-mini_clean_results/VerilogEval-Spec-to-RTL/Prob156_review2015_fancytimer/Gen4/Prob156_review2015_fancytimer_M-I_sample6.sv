module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    typedef enum logic [1:0] {
        IDLE       = 2'd0, // Searching for pattern 1101
        LOAD_DELAY = 2'd1, // Loading 4 delay bits MSB first
        COUNTING   = 2'd2, // Counting timer cycles
        DONE       = 2'd3  // Timer done, waiting for ack
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay bits register and count of loaded bits
    reg [2:0] delay_bit_count; // counts bits loaded, 0 to 4
    reg [3:0] delay_reg;

    // Timer counters
    reg [11:0] cycle_counter;   // counts 0..999 clock cycles
    reg [4:0]  tick_counter;    // counts delay+1 down to 0, max 16 requires 5 bits

    // Detect start pattern "1101"
    wire pattern_match = (pattern_shift == 4'b1101);

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: if (pattern_match) next_state = LOAD_DELAY;
            LOAD_DELAY: if (delay_bit_count == 4) next_state = COUNTING;
            COUNTING: 
                // When tick_counter == 0 and cycle_counter == 999, counting complete
                if ((tick_counter == 0) && (cycle_counter == 12'd999))
                    next_state = DONE;
            DONE: if (ack) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_bit_count <= 3'd0;
            delay_reg <= 4'd0;
            cycle_counter <= 12'd0;
            tick_counter <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift pattern register for pattern detection only in IDLE
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in 4 delay bits MSB first, shift left and insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;

                    // Do not update pattern_shift during LOAD_DELAY
                    pattern_shift <= pattern_shift;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    // Freeze pattern_shift during COUNTING
                    pattern_shift <= pattern_shift;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 12'd999) begin
                        cycle_counter <= 12'd0;
                        if (tick_counter > 0)
                            tick_counter <= tick_counter - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // Output remaining count: tick_counter - 1 when tick_counter>0, else 0
                    if (tick_counter == 0)
                        count <= 4'd0;
                    else
                        count <= tick_counter - 1;
                end

                DONE: begin
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    delay_bit_count <= 3'd0;
                    delay_reg <= delay_reg; // Keep loaded delay if desired (optional)
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Safety fallback reset
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 12'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Latch tick_counter and cycle_counter at LOAD_DELAY -> COUNTING transition
            if ((state == LOAD_DELAY) && (next_state == COUNTING)) begin
                tick_counter <= delay_reg + 5'd1;
                cycle_counter <= 12'd0;
            end
        end
    end

endmodule