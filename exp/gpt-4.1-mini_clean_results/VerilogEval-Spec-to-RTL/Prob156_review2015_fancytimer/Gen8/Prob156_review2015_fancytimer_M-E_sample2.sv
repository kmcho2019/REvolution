module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State encoding (Moore FSM)
    typedef enum logic [1:0] {
        SEARCH      = 2'b00,
        LOAD_DELAY  = 2'b01,
        COUNTING    = 2'b10,
        DONE        = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection and delay loading
    reg [3:0] shift_reg;

    // Delay register (loaded MSB first during LOAD_DELAY)
    reg [3:0] delay_reg;

    // Counter for bits loaded in LOAD_DELAY (0 to 4)
    reg [2:0] load_bit_count;

    // Timer counters
    reg [9:0] cycle_counter;  // counts 0..999 clock cycles per tick
    reg [3:0] tick_counter;   // counts remaining ticks (delay+1)

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and control signals
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // When pattern detected (shift_reg == 1101), go to LOAD_DELAY
                if (shift_reg == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                // After loading 4 delay bits, transition to COUNTING
                if (load_bit_count == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                // When finished all ticks and cycle_counter reached 999, go to DONE
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end
            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Shift register for input data and load_bit_count management
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            load_bit_count <= 3'd0;
            delay_reg <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    // Shift input data in for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                    load_bit_count <= 3'd0;
                    delay_reg <= 4'd0;
                end
                LOAD_DELAY: begin
                    // Shift in next 4 bits MSB first for delay_reg
                    // Shift left delay_reg by 1 and insert new bit into LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1'b1;
                end
                default: begin
                    // No shifting/loading in other states
                    shift_reg <= shift_reg;
                    load_bit_count <= load_bit_count;
                    delay_reg <= delay_reg;
                end
            endcase
        end
    end

    // Timer counting logic and outputs
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    // Idle state, no counting
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care, but set to zero
                end
                LOAD_DELAY: begin
                    // Not counting yet
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle after entering COUNTING, initialize counters
                    if (state != next_state) begin
                        // New state entered
                        cycle_counter <= 10'd0;
                        // tick_counter initialized to delay + 1
                        tick_counter <= delay_reg + 1'b1;
                        // count output starts at delay value
                        count <= delay_reg;
                    end else begin
                        // Normal counting in COUNTING state
                        if (cycle_counter == 10'd999) begin
                            // Completed one 1000-cycle tick
                            cycle_counter <= 10'd0;

                            if (tick_counter != 0) begin
                                tick_counter <= tick_counter - 1'b1;

                                if (tick_counter > 1)
                                    count <= tick_counter - 2'b10; // count = tick_counter - 2
                                else
                                    count <= 4'd0; // last tick, count = 0
                            end else begin
                                // Should not occur: counting done
                                count <= 4'd0;
                            end
                        end else begin
                            cycle_counter <= cycle_counter + 1'b1;
                            // Hold count steady during 1000-cycle interval
                            count <= count;
                        end
                    end
                end
                DONE: begin
                    // Counting done, waiting for ack
                    counting <= 1'b0;
                    done <= 1'b1;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'bxxxx; // don't care
                end
                default: begin
                    // Safety default
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0000;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule