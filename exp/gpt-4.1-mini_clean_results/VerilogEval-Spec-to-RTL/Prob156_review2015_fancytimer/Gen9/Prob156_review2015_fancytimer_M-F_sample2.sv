module TopModule(
    input           clk,
    input           reset,  // synchronous active high
    input           data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // FSM states encoding
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (holds last 4 bits received)
    // MSB first input: shift left and append new bit at LSB
    reg [3:0] pattern_shift;

    // Delay loading registers
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // 0..4 bits loaded

    // Counting registers
    reg [9:0] cycle_count;       // counts 0..999 cycles per block
    reg [4:0] blocks_remaining;  // counts (delay+1) blocks (max 16)
                                // 5 bits enough for 0..16

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_count <= 10'd0;
            blocks_remaining <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0; // stable value in non-counting states

                    // Shift pattern left, append data bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay registers and counters
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0; // stable in non-counting states

                    // Shift delay left, insert new bit at LSB (MSB first load)
                    delay_reg <= {delay_reg[2:0], data};

                    // Increment bits loaded
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Keep pattern_shift stable (not needed here)
                    pattern_shift <= pattern_shift;

                    // Clear counters
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // Keep pattern_shift, delay_reg unchanged
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    // Count cycles 0..999
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;

                        // Decrement blocks_remaining if > 0
                        if (blocks_remaining > 0)
                            blocks_remaining <= blocks_remaining - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // count output = blocks_remaining - 1 if blocks_remaining>0 else 0
                    // This shows remaining blocks in the desired format (delay down to 0)
                    count <= (blocks_remaining > 0) ? (blocks_remaining - 1'b1) : 4'd0;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0; // stable in done state

                    // Hold registers (no change)
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                end

                default: begin
                    // Should not happen: safe defaults
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_count <= 10'd0;
                    blocks_remaining <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Detect pattern 1101 on pattern_shift MSB first
                // pattern_shift[3:0] holds last 4 bits shifted in MSB first:
                // The earliest received bit is at bit3 (MSB), newest at bit0 (LSB).
                // So the pattern 1101 means bits[3:0] = 4'b1101 = bit3=1, bit2=1, bit1=0, bit0=1
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 bits delay loaded, move to COUNTING
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When blocks_remaining reaches zero after finishing a 1000-cycle block,
                // i.e., blocks_remaining == 0 and cycle_count == 999, move to DONE
                if ((blocks_remaining == 5'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE and start pattern detection again
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Initialization on LOAD_DELAY->COUNTING transition
    reg load_to_counting;
    reg prev_state_load_delay;

    always @(posedge clk) begin
        if (reset) begin
            prev_state_load_delay <= 1'b0;
        end else begin
            prev_state_load_delay <= (state == LOAD_DELAY);
        end
    end

    assign load_to_counting = (prev_state_load_delay && (next_state == COUNTING));

    always @(posedge clk) begin
        if (reset) begin
            blocks_remaining <= 5'd0;
            cycle_count <= 10'd0;
            count <= 4'd0;
        end else if (load_to_counting) begin
            // Initialize blocks_remaining = delay + 1
            // delay_reg holds the delay bits loaded MSB first correctly
            blocks_remaining <= delay_reg + 1'b1;
            cycle_count <= 10'd0;

            // Set count output to delay (blocks_remaining - 1)
            count <= delay_reg;
        end
    end

endmodule