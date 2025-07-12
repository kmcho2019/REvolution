module TopModule (
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM States
    parameter IDLE         = 3'd0;
    parameter START_DETECT = 3'd1;
    parameter DELAY_LOAD   = 3'd2;
    parameter COUNT        = 3'd3;
    parameter WAIT_ACK     = 3'd4;

    reg [2:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 delay bits MSB first
    reg [3:0] delay_reg;

    // Counter for how many delay bits loaded (0 to 4)
    reg [2:0] delay_bits_loaded;

    // Cycle counter: counts 0..999 clock cycles for one tick
    reg [9:0] cycle_counter;

    // Tick counter: counts down from delay+1 to 0 ticks
    reg [4:0] tick_counter;

    // Synchronize FSM and counters
    always @(posedge clk) begin
        if (reset) begin
            // Reset all signals
            state <= IDLE;

            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;

            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Initialize pattern detection
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                START_DETECT: begin
                    // Shift in data LSB first (old bits shift left, new bit enters at bit0)
                    // The problem states pattern 1101 detected on incoming bits. 
                    // To check bits arriving MSB first or LSB first:
                    // Given pattern 1101, shifting left and adding LSB newest bit 
                    // is a typical approach.

                    pattern_shift <= {pattern_shift[2:0], data};

                    // Keep other regs stable
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB first, i.e. first bit is delay[3]
                    // Shift delay_reg left by 1 and insert new bit at LSB:
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_counter counts 1000 cycles per tick
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 5'd0)
                            tick_counter <= tick_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // count output shows current remaining tick value (delay down to 0)
                    // count holds tick_counter during the 1000 cycles for that tick
                    count <= tick_counter[3:0];
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;

                    count <= 4'd0;          // don't-care, drive 0 for clarity
                    cycle_counter <= 10'd0; // clear counters as idle
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Just in case
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                next_state = START_DETECT;
            end

            START_DETECT: begin
                // Wait until pattern_shift matches 4'b1101
                // pattern_shift updates at clock edge, so here compare current pattern_shift
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = START_DETECT;
            end

            DELAY_LOAD: begin
                // After 4 bits loaded, move to COUNT
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // When tick_counter reaches 0 and cycle_counter finishes 1000 cycles,
                // counting is done
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                // Wait for ack input to return to START_DETECT
                if (ack)
                    next_state = START_DETECT;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = IDLE;
        endcase
    end

    // When entering COUNT state (on transition), initialize tick_counter = delay_reg + 1
    // and reset cycle_counter
    // Detect transition with a simple registered previous state signal

    reg [2:0] prev_state;
    always @(posedge clk) begin
        if (reset) begin
            prev_state <= IDLE;
        end else begin
            prev_state <= state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            tick_counter <= 5'd0;
            cycle_counter <= 10'd0;
        end else begin
            // Initialize tick_counter only on transition DELAY_LOAD->COUNT
            if ((prev_state == DELAY_LOAD) && (state == COUNT)) begin
                // delay_reg is 4 bits, add 1 to get tick count (max 17)
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule