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
    typedef enum logic [1:0] {
        SEARCH     = 2'd0,
        DELAY_LOAD = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    // Shift left, insert new data bit at LSB (MSB-first serial input)
    reg [3:0] pattern_shift;

    // Delay register - load 4 bits MSB first by shifting left and inserting data at LSB
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;  // counts 0 to 4

    // Cycle counter: counts 0..999 cycles per tick
    reg [9:0] cycle_counter;

    // Tick counter: counts remaining ticks down from delay+1 to 0
    reg [4:0] tick_counter;

    // Register to hold stable current count output during 1000 cycle interval
    reg [3:0] current_count;

    // Register previous state to detect state transitions
    state_t prev_state;

    // Synchronous sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
            current_count <= 4'd0;
            prev_state <= SEARCH;
        end else begin
            prev_state <= state;
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern_shift left and insert data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= delay_reg; // hold previous delay_reg for safety
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift delay_reg left, insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // cycle_counter increments 0..999
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 5'd0) begin
                            tick_counter <= tick_counter - 1'b1;
                            // Update current_count to one less tick if tick_counter > 1 else 0
                            if (tick_counter > 5'd1) begin
                                current_count <= tick_counter - 1'b1;
                            end else begin
                                current_count <= 4'd0;
                            end
                        end else begin
                            tick_counter <= 5'd0;
                            current_count <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        // current_count stable during 1000 cycles
                        current_count <= current_count;
                        tick_counter <= tick_counter;
                    end
                    count <= current_count;
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    current_count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end

                default: begin
                    // Should not happen, reset to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    current_count <= 4'd0;
                end
            endcase

            // Initialize counting on transition DELAY_LOAD->COUNT
            if ((prev_state == DELAY_LOAD) && (state == COUNT)) begin
                tick_counter <= delay_reg + 5'd1; // delay + 1
                cycle_counter <= 10'd0;
                current_count <= delay_reg;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Pattern detection: match 1101 = 4'b1101
                // pattern_shift holds bits shifted in MSB first
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
                else
                    next_state = SEARCH;
            end

            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = DELAY_LOAD;
            end

            COUNT: begin
                // Done counting when tick_counter=0 and cycle_counter=999 (end of last tick)
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule