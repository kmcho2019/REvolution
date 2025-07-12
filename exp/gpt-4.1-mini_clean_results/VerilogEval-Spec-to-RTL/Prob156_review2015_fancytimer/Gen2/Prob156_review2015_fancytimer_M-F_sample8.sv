module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// FSM states
localparam SEARCH     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNT      = 2'd2;
localparam DONE       = 2'd3;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101 (serial input MSB first)
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Counters for timing
// ms_count counts 0..999 clock cycles (one "ms" block)
// step_count counts down delay steps from delay_reg down to 0
reg [9:0] ms_count;      // counts 0 to 999 (10 bits)
reg [3:0] step_count;    // counts down from delay to 0

// Count bits loaded for delay (0..4)
reg [2:0] load_bit_count;

//
// Sequential FSM and counters
//
always @(posedge clk) begin
    if (reset) begin
        // Reset all registers
        state <= SEARCH;
        pattern_shift <= 4'b0000;
        delay_reg <= 4'b0000;
        load_bit_count <= 3'd0;
        ms_count <= 10'd0;
        step_count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        state <= next_state;

        case(state)
            SEARCH: begin
                // Shift in new data bit (LSB) for pattern detection MSB first
                // Shift left and insert data at LSB
                pattern_shift <= {pattern_shift[2:0], data};

                // Clear control signals
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;

                // Reset counters
                load_bit_count <= 3'd0;
                ms_count <= 10'd0;
                step_count <= 4'd0;
                delay_reg <= delay_reg; // hold delay_reg, no change until LOAD_DELAY
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first:
                // Shift left by 1, put new bit at LSB
                delay_reg <= {delay_reg[2:0], data};

                // Increment load bit count
                load_bit_count <= load_bit_count + 1'b1;

                // Counting and done low in this state
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;

                // pattern_shift holds; no change in LOAD_DELAY
                pattern_shift <= pattern_shift;

                // ms_count and step_count reset
                ms_count <= 10'd0;
                step_count <= 4'd0;
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;

                // pattern_shift and load_bit_count hold
                pattern_shift <= pattern_shift;
                load_bit_count <= load_bit_count;

                // ms_count increments each clock cycle; counts 0..999
                if (ms_count == 10'd999) begin
                    ms_count <= 10'd0;

                    // step_count counts down each time ms_count wraps
                    if (step_count != 0) begin
                        step_count <= step_count - 1'b1;
                    end
                    // else step_count is zero; remain zero until transition to DONE
                end else begin
                    ms_count <= ms_count + 1'b1;
                end

                // count outputs current step_count (remaining delay steps)
                count <= step_count;
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;

                // Hold pattern_shift and delay_reg unchanged
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;

                // Reset counters and outputs don't-care
                count <= 4'b0000;
                ms_count <= 10'd0;
                step_count <= 4'd0;
                load_bit_count <= 3'd0;
            end

            default: begin
                // Default fallback
                state <= SEARCH;
                pattern_shift <= 4'b0000;
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                ms_count <= 10'd0;
                step_count <= 4'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end
        endcase
    end
end

//
// Next state combinational logic
//
always @(*) begin
    next_state = state;
    case(state)
        SEARCH: begin
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            if (load_bit_count == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Transition to DONE when step_count=0 and ms_count=999 (last cycle)
            if ((step_count == 0) && (ms_count == 10'd999))
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            // Wait for ack to return to SEARCH
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

//
// On entering COUNT state, initialize step_count and ms_count
//
always @(posedge clk) begin
    if (reset) begin
        // already handled
    end else begin
        if ((state != COUNT) && (next_state == COUNT)) begin
            // Initialize step_count with delay_reg (loaded delay)
            // step_count counts down from delay_reg to 0
            step_count <= delay_reg;

            // Initialize ms_count to zero
            ms_count <= 10'd0;
        end
    end
end

endmodule