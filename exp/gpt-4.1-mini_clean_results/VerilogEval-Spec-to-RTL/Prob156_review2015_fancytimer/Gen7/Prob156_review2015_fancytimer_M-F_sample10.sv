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

    // Pattern detection shift register (MSB side is oldest bit)
    reg [3:0] pattern_shift;

    // Delay loading: store bits MSB first as per bit index = 3 - load_bits_cnt
    reg [2:0] load_bits_cnt;     // counts 0..3 during loading delay bits
    reg [3:0] delay_reg;

    // Counting related
    reg [9:0] cycle_subcount;    // counts 0..999 for each 1000-cycle block
    reg [3:0] remaining_ticks;   // counts down from delay_reg to 0

    // Synchronous FSM state register and datapath
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            load_bits_cnt <= 3'd0;
            delay_reg <= 4'd0;
            cycle_subcount <= 10'd0;
            remaining_ticks <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift pattern_shift left by 1, input new bit at LSB
                    // So pattern_shift = {pattern_shift[2:0], data};
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear other registers
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Keep pattern_shift unchanged (not needed in LOAD_DELAY)
                    pattern_shift <= pattern_shift;

                    // Load delay bits MSB first:
                    // delay_reg[3 - load_bits_cnt] <= data each cycle.
                    // To do this, create a temp reg and update only that bit.
                    // But in synchronous block must assign whole delay_reg:
                    // So build new delay_reg with updated bit:

                    // We'll do a simple method: delay_reg = delay_reg with one bit replaced.

                    // Create a temporary register:
                    reg [3:0] delay_next;
                    delay_next = delay_reg;
                    delay_next[3 - load_bits_cnt] = data;
                    delay_reg <= delay_next;

                    // Increment load_bits_cnt
                    load_bits_cnt <= load_bits_cnt + 1'b1;

                    // Reset other counters and outputs
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= remaining_ticks;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift;  // hold pattern_shift unchanged
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_subcount increments each clock
                    if (cycle_subcount == 10'd999) begin
                        cycle_subcount <= 10'd0;

                        if (remaining_ticks != 0) begin
                            remaining_ticks <= remaining_ticks - 1'b1;
                        end
                        // else remain zero
                    end else begin
                        cycle_subcount <= cycle_subcount + 1'b1;
                        remaining_ticks <= remaining_ticks; // hold same value within block
                    end

                    count <= remaining_ticks;
                end

                DONE_WAIT: begin
                    pattern_shift <= pattern_shift;
                    load_bits_cnt <= load_bits_cnt;
                    delay_reg <= delay_reg;
                    cycle_subcount <= 10'd0;
                    remaining_ticks <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    load_bits_cnt <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_subcount <= 10'd0;
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
                // Counting finishes when remaining_ticks=0 AND cycle_subcount=999 (end of last 1000-cycle block)
                if ((remaining_ticks == 4'd0) && (cycle_subcount == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

endmodule