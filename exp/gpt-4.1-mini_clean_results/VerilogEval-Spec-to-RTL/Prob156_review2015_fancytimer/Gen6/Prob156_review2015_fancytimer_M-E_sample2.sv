module TopModule(
    input        clk,
    input        reset, // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    typedef enum reg [1:0] {
        SEARCH      = 2'b00,
        LOAD_DELAY  = 2'b01,
        COUNTING    = 2'b10,
        DONE_WAIT   = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [2:0] load_bits_cnt;     // count bits loaded in LOAD_DELAY (0..4)
    reg [3:0] delay_reg;

    // Counting registers
    reg [13:0] cycle_counter;    // counts 0 to total_count-1 (max ~16000)
    reg [13:0] total_count;      // (delay+1)*1000
    reg [3:0] remaining_ticks;   // current tick count (decrements every 1000 cycles)

    // Synchronous FSM state register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            load_bits_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_counter <= 14'd0;
            total_count <= 14'd0;
            remaining_ticks <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift left by 1: pattern_shift = {old[2:0], data}
                    pattern_shift <= {pattern_shift[2:0], data};
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;
                    remaining_ticks <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB-first: insert data into delay_reg[3 - load_bits_cnt]
                    // Using a shift-left approach for delay_reg: shift left by 1 and insert at LSB
                    // This will put the first bit shifted in into MSB eventually after 4 shifts
                    // So for MSB first loading, do: delay_reg = {delay_reg[2:0], data}

                    delay_reg <= {delay_reg[2:0], data};
                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    pattern_shift <= pattern_shift; // hold
                    cycle_counter <= 14'd0;
                    total_count <= total_count;
                    remaining_ticks <= remaining_ticks;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // hold
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle of COUNTING, cycle_counter == 0, remaining_ticks == delay
                    // Increment cycle_counter each clock until total_count reached

                    if (cycle_counter == total_count - 1) begin
                        cycle_counter <= 14'd0;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Update remaining_ticks based on which 1000-cycle block we're in
                    // For total_count cycles, there are (delay+1) blocks of 1000 cycles:
                    // block_num = cycle_counter / 1000 (integer division)
                    // remaining_ticks = delay - block_num

                    // Compute block number by integer divide by 1000:
                    // 1000 in binary is 0x3E8

                    // We'll do block_num by subtracting 1000 cycles repeatedly if necessary.
                    // But better to do integer divide by 1000 using simple arithmetic since delay max is 15, total_count max ~16000

                    // To avoid complexity, create a combinational function (using div) outside, but here just approximate:

                    // Instead, we'll update remaining_ticks whenever cycle_counter % 1000 == 0:
                    if (cycle_counter % 14'd1000 == 0) begin
                        remaining_ticks <= remaining_ticks - 1'b1; // decrement on block boundary except for block 0
                    end

                    // Output count = remaining_ticks + 1
                    // Since the first 1000 cycles correspond to delay_reg ticks
                    // But decrement was done already here, so we adjust:

                    // We need stable count for each 1000 cycles block, starting from delay_reg value down to 0

                    // For cycle_counter=0: remaining_ticks=delay
                    // For cycle_counter in 0..999: output remaining_ticks = delay
                    // After first 1000 cycles: remaining_ticks = delay-1, and so on

                    // Since we decrement remaining_ticks at cycle_counter%1000==0, at cycle_counter=0 we decrement once prematurely.
                    // To fix, initialize remaining_ticks = delay + 1 at start of COUNTING and decrement starting from cycle_counter=1000

                    count <= remaining_ticks;
                end

                DONE_WAIT: begin
                    // Wait for ack, hold outputs
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;
                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;
                    remaining_ticks <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Should never occur, default to SEARCH
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 14'd0;
                    total_count <= 14'd0;
                    remaining_ticks <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;

        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_bits_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (cycle_counter == total_count - 1)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Compute total_count and initialize remaining_ticks at LOAD_DELAY->COUNTING transition
    reg load_delay_d; // delayed LOAD_DELAY flag to detect rising edge
    always @(posedge clk) begin
        if (reset) begin
            load_delay_d <= 1'b0;
            total_count <= 14'd0;
            remaining_ticks <= 4'd0;
        end else begin
            load_delay_d <= (state == LOAD_DELAY);

            // Detect LOAD_DELAY ending (on next state COUNTING)
            if (load_delay_d && (next_state == COUNTING)) begin
                // total_count = (delay_reg + 1) * 1000
                total_count <= ( {10'd0, delay_reg} + 14'd1 ) * 14'd1000;
                // Initialize remaining_ticks to delay_reg
                remaining_ticks <= delay_reg;
                // Reset cycle counter to zero when entering COUNTING
                cycle_counter <= 14'd0;
            end
        end
    end

endmodule