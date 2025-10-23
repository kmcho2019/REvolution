module TopModule (
    input         clk,
    input         reset,     // synchronous active-high reset
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH    = 2'b00,
        DELAY_LOAD= 2'b01,
        COUNTING  = 2'b10,
        WAIT_ACK  = 2'b11
    } state_t;
    reg [1:0] state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_shift;

    // Delay load register and counter
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;   // counts 0 to 4 bits loaded

    // Counting registers
    reg [13:0] total_cycles;       // total cycles to count: (delay+1)*1000 max 16k cycles fit in 14 bits
    reg [13:0] cycle_count;        // counts up to total_cycles

    // For output delay segment counting: number of full 1000-cycle segments remaining (0..delay)
    // count output reflects current remaining delay segment: delay ... 0
    reg [3:0] remaining_segments;

    // Sequential FSM state update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = DELAY_LOAD;
            end
            DELAY_LOAD: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (cycle_count == total_cycles)
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
            default: next_state = SEARCH;
        endcase
    end

    // Shift register and counting logic
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift     <= 4'b0000;
            delay_reg         <= 4'b0000;
            delay_bits_loaded <= 3'd0;
            total_cycles      <= 14'd0;
            cycle_count       <= 14'd0;
            remaining_segments<= 4'd0;
            count             <= 4'd0;
            counting          <= 1'b0;
            done              <= 1'b0;
        end else begin
            case(state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_count <= 14'd0;
                    total_cycles <= 14'd0;
                    remaining_segments <= 4'd0;

                    // Shift in data MSB first for pattern detection
                    // pattern_shift = {old bits[2:0], new_bit}
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                DELAY_LOAD: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Continue shifting in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1;

                    // pattern_shift remains unchanged until next SEARCH
                    pattern_shift <= pattern_shift;
                    cycle_count <= 14'd0;
                    total_cycles <= 14'd0;
                    remaining_segments <= 4'd0;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Increment cycle counter
                    if (cycle_count < total_cycles)
                        cycle_count <= cycle_count + 1;

                    // Calculate remaining segments: floor division by 1000 of remaining cycles
                    // Since total_cycles = (delay+1)*1000,
                    // and count = number of 1000-cycle segments remaining (delay down to 0)
                    // We calculate remaining_segments = delay - number of full 1000-cycle segments counted so far
                    // number of full 1000-cycle segments counted = cycle_count / 1000

                    // Use integer division: cycle_count / 1000
                    // To avoid division operator, use a small combinational function here with an internal variable

                    // We'll compute segments_elapsed = cycle_count / 1000 (max 15)
                    // 1000 decimal = 0x3E8
                    // We can do this with simple logic because max is 15*1000=15000

                    // For simplicity, use arithmetic division (synthesis tools handle)
                    // remaining_segments = delay_reg - segments_elapsed;

                    count <= remaining_segments;

                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // total_cycles remains constant
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;    // don't-care is zero for clean outputs

                    // Hold all other registers constant except reset or next SEARCH
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_count <= cycle_count;
                    total_cycles <= total_cycles;
                    remaining_segments <= remaining_segments;
                end

                default: begin
                    // Safe defaults
                    pattern_shift     <= 4'b0000;
                    delay_reg         <= 4'b0000;
                    delay_bits_loaded <= 3'd0;
                    total_cycles      <= 14'd0;
                    cycle_count       <= 14'd0;
                    remaining_segments<= 4'd0;
                    count             <= 4'd0;
                    counting          <= 1'b0;
                    done              <= 1'b0;
                end
            endcase

            // At the clock when state just changed from DELAY_LOAD to COUNTING,
            // initialize total_cycles and remaining_segments
            if ((state == DELAY_LOAD) && (next_state == COUNTING)) begin
                // total_cycles = (delay + 1) * 1000
                total_cycles <= (delay_reg + 1) * 14'd1000;
                cycle_count <= 14'd0;
                // remaining_segments start as delay_reg (the delay value)
                remaining_segments <= delay_reg;
                count <= delay_reg;
            end

            // Update remaining_segments in COUNTING state based on cycle_count
            if (state == COUNTING) begin
                // Calculate how many full 1000-cycle segments elapsed
                integer segments_elapsed;
                segments_elapsed = cycle_count / 1000;

                // Clamp segments_elapsed to at most delay_reg + 1
                if (segments_elapsed > delay_reg + 1)
                    segments_elapsed = delay_reg + 1;

                // remaining_segments = delay_reg - segments_elapsed, clamp at 0
                if (segments_elapsed > delay_reg)
                    remaining_segments <= 0;
                else
                    remaining_segments <= delay_reg - segments_elapsed;
            end
        end
    end

endmodule