module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active high reset
    input  wire       data,     // serial data input
    output reg  [3:0] count,    // remaining time blocks output
    output reg        counting, // high while counting
    output reg        done,     // high when timer expired, waiting for ack
    input  wire       ack       // acknowledge input
);

// FSM states
localparam ST_PATTERN_DETECT = 2'd0;
localparam ST_DELAY_LOAD     = 2'd1;
localparam ST_COUNTING       = 2'd2;
localparam ST_WAIT_ACK       = 2'd3;

reg [1:0] state, next_state;

// Shift register for pattern detection (4 bits)
reg [3:0] pattern_shift;

// Delay register (4 bits, MSB first)
reg [3:0] delay_reg;
reg [2:0] delay_bits_count; // counts bits shifted into delay_reg (0 to 4)

// 14-bit down-counter for total cycles left
// max delay is 15, so max cycles = 16*1000 = 16000 < 2^14=16384
reg [13:0] cycle_countdown;

// Combinational next state logic
always @(*) begin
    next_state = state;
    case(state)
        ST_PATTERN_DETECT: begin
            if (pattern_shift == 4'b1101)
                next_state = ST_DELAY_LOAD;
            else
                next_state = ST_PATTERN_DETECT;
        end

        ST_DELAY_LOAD: begin
            if (delay_bits_count == 3'd4)
                next_state = ST_COUNTING;
            else
                next_state = ST_DELAY_LOAD;
        end

        ST_COUNTING: begin
            if (cycle_countdown == 14'd0)
                next_state = ST_WAIT_ACK;
            else
                next_state = ST_COUNTING;
        end

        ST_WAIT_ACK: begin
            if (ack)
                next_state = ST_PATTERN_DETECT;
            else
                next_state = ST_WAIT_ACK;
        end

        default: next_state = ST_PATTERN_DETECT;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Initialize everything
        state <= ST_PATTERN_DETECT;
        pattern_shift <= 4'd0;
        delay_reg <= 4'd0;
        delay_bits_count <= 3'd0;
        cycle_countdown <= 14'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'd0;
    end else begin
        state <= next_state;
        case(state)
            ST_PATTERN_DETECT: begin
                // Shift in data bit
                pattern_shift <= {pattern_shift[2:0], data};
                // Reset delay loading registers
                delay_bits_count <= 3'd0;
                delay_reg <= 4'd0;
                // Clear cycle counter
                cycle_countdown <= 14'd0;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0; // don't care value
            end

            ST_DELAY_LOAD: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                delay_bits_count <= delay_bits_count + 1'b1;
                // Pattern shift register holds value (ignored)
                pattern_shift <= pattern_shift;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
                cycle_countdown <= 14'd0;
            end

            ST_COUNTING: begin
                // Hold pattern_shift and delay_bits_count stable
                pattern_shift <= pattern_shift;
                delay_bits_count <= delay_bits_count;
                delay_reg <= delay_reg;

                // Decrement the cycle counter if not zero
                if (cycle_countdown > 14'd0) 
                    cycle_countdown <= cycle_countdown - 14'd1;
                else
                    cycle_countdown <= 14'd0;

                counting <= 1'b1;
                done <= 1'b0;
            end

            ST_WAIT_ACK: begin
                // Hold values stable, clear counters
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bits_count <= delay_bits_count;
                cycle_countdown <= 14'd0;
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'd0; // don't care
            end

            default: begin
                state <= ST_PATTERN_DETECT;
                pattern_shift <= 4'd0;
                delay_reg <= 4'd0;
                delay_bits_count <= 3'd0;
                cycle_countdown <= 14'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
            end
        endcase

        // On transition from DELAY_LOAD to COUNTING: initialize countdown
        if (state == ST_DELAY_LOAD && next_state == ST_COUNTING) begin
            // Initialize cycle_countdown = (delay+1)*1000
            // delay_reg + 1 fits in 5 bits max 16, 16*1000=16000 fits 14 bits
            cycle_countdown <= (delay_reg + 1) * 14'd1000;
        end
    end
end

// Combinational logic to compute count output during counting state
// count = number of remaining 1000-cycle blocks: counts down from delay_reg to 0 every 1000 cycles

always @(*) begin
    if (state == ST_COUNTING) begin
        // Calculate remaining 1000-cycle blocks:
        // cycle_countdown counts down total cycles left, total cycles = (delay_reg+1)*1000
        // Number of blocks remaining = ceil(cycle_countdown / 1000) - 1
        // To avoid division, use bit shift (>> 10 = divide by 1024) with adjustment for rounding
        
        // Add 999 for ceiling division by 1000:
        // We approximate division by 1000 as division by 1024 (2^10),
        // So add 1023 (all ones in lower 10 bits) for rounding in 1024 divide:
        
        // Then:
        // remaining_blocks = ((cycle_countdown + 999) / 1000) - 1
        // Approximate as:
        // remaining_blocks = ((cycle_countdown + 1023) >> 10) - 1
        
        // Clamp to [0, delay_reg]
        
        // Compute adjusted value
        reg [13:0] adjusted_cycle;
        reg [4:0] remaining_blocks;

        adjusted_cycle = cycle_countdown + 14'd999; // add 999 for ceil division
        remaining_blocks = (adjusted_cycle >> 10);   // divide by 1024 approx
        
        // remaining_blocks could be 0 to delay_reg+1
        // We subtract 1 to get zero-based index
        if (remaining_blocks == 0) begin
            count = delay_reg;
        end else if (remaining_blocks > (delay_reg + 1)) begin
            count = 4'd0;
        end else begin
            count = (delay_reg + 1) - remaining_blocks;
        end
    end else begin
        count = 4'd0; // don't care outside counting
    end
end

endmodule