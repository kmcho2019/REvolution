module TopModule (
    input        clk,
    input        reset,   // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH   = 2'd0,
        LOAD     = 2'd1,
        COUNT    = 2'd2,
        WAIT_ACK = 2'd3
    } state_t;
    state_t state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] load_bit_cnt; // counts 0..3 for 4 bits loaded

    // Cycle counter (16 bits)
    reg [15:0] cycle_counter;

    // Internal signals for counting duration and remaining ticks
    wire [15:0] count_limit;      // (delay+1)*1000 - 1
    wire [15:0] total_cycles;     // (delay+1)*1000
    wire [3:0]  tick_remaining;   // remaining count value output
    reg  [15:0] count_limit_reg;  // stored limit on counting start

    // Calculate total cycles = (delay+1)*1000
    wire [7:0] delay_plus_1 = delay_reg + 1;
    assign total_cycles = delay_plus_1 * 1000;         // This can overflow 16 bits, but delay+1 max 16 so 16000 fits in 16 bits
    assign count_limit = total_cycles - 1;

    // Detect pattern 1101 on pattern_shift
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH:  next_state = pattern_detected ? LOAD : SEARCH;
            LOAD:    next_state = (load_bit_cnt == 3'd4) ? COUNT : LOAD;
            COUNT:   next_state = (cycle_counter == count_limit_reg) ? WAIT_ACK : COUNT;
            WAIT_ACK: next_state = ack ? SEARCH : WAIT_ACK;
            default: next_state = SEARCH;
        endcase
    end

    // Sequential logic for FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'd0;
            load_bit_cnt <= 3'd0;
            cycle_counter <= 16'd0;
            count_limit_reg <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in pattern bits MSB-first (shift left, insert data LSB)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading and counters
                    delay_reg <= delay_reg;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                LOAD: begin
                    // Shift in delay bits MSB-first on each clk (4 bits)
                    // Shift left and insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_cnt <= load_bit_cnt + 1;

                    // Freeze pattern_shift (optional)
                    pattern_shift <= pattern_shift;

                    // Clear counting counter during load
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                COUNT: begin
                    // Freeze pattern_shift
                    pattern_shift <= pattern_shift;

                    // Increment cycle counter until count_limit_reg reached
                    if (cycle_counter < count_limit_reg)
                        cycle_counter <= cycle_counter + 1;

                    // Other registers stay
                    delay_reg <= delay_reg;
                    load_bit_cnt <= load_bit_cnt;
                    count_limit_reg <= count_limit_reg;
                end

                WAIT_ACK: begin
                    // Freeze pattern_shift and all registers except state
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end

                default: begin
                    // Safety reset all registers
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'd0;
                    load_bit_cnt <= 3'd0;
                    cycle_counter <= 16'd0;
                    count_limit_reg <= 16'd0;
                end
            endcase

            // On transition LOAD->COUNT, latch count_limit_reg to (delay+1)*1000 -1 for fixed counting
            if (state == LOAD && next_state == COUNT) begin
                count_limit_reg <= (delay_reg + 1) * 1000 - 1;
                cycle_counter <= 16'd0;
            end
        end
    end

    // Output logic combinational
    always @(*) begin
        counting = 1'b0;
        done     = 1'b0;
        count    = 4'bxxxx;

        case(state)
            SEARCH: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            LOAD: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end

            COUNT: begin
                counting = 1'b1;
                done = 1'b0;
                // Calculate remaining ticks = delay - (cycle_counter / 1000)
                // cycle_counter / 1000 implemented via integer division approximation
                // Since 1000 ~ 2^10 - 24, use divider or compare.
                // Use division by subtracting multiples of 1000:
                // quotient = cycle_counter / 1000 = number of full 1000-cycle intervals elapsed

                // To implement this combinationally, use simple compare and subtraction:
                // Since delay max 15, max total cycles 16000, so quotient fits in 5 bits (max 16).
                // quotient = cycle_counter / 1000
                // Use a small combinational divider:

                reg [4:0] quotient;
                integer i;
                begin
                    quotient = 0;
                    for (i = 15; i >= 0; i = i - 1) begin
                        if (cycle_counter >= (1000 * i))
                            quotient = i[4:0];
                    end
                end

                // remaining ticks = delay_reg - quotient, saturate at zero (should not go below zero)
                if (delay_reg >= quotient[3:0])
                    count = delay_reg - quotient[3:0];
                else
                    count = 4'd0;
            end

            WAIT_ACK: begin
                counting = 1'b0;
                done = 1'b1;
                count = 4'bxxxx;
            end

            default: begin
                counting = 1'b0;
                done = 1'b0;
                count = 4'bxxxx;
            end
        endcase
    end

endmodule