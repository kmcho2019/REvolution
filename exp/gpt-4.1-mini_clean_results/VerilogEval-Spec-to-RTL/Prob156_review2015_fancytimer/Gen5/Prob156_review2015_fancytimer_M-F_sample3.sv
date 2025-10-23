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
        count <= 4'b0;
    end else begin
        state <= next_state;
        case(state)
            ST_PATTERN_DETECT: begin
                // Shift in data bit
                pattern_shift <= {pattern_shift[2:0], data};
                // Reset delay loading
                delay_bits_count <= 3'd0;
                delay_reg <= 4'd0;
                // Clear cycle counter
                cycle_countdown <= 14'd0;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                // count output handled combinationally
            end

            ST_DELAY_LOAD: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                delay_bits_count <= delay_bits_count + 1'b1;
                // pattern_shift ignored here, hold value
                pattern_shift <= pattern_shift;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                cycle_countdown <= 14'd0;
            end

            ST_COUNTING: begin
                // Hold previous values for pattern_shift, delay_reg, delay_bits_count
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bits_count <= delay_bits_count;

                // Decrement the cycle counter if not zero
                if (cycle_countdown > 14'd0) 
                    cycle_countdown <= cycle_countdown - 14'd1;
                else
                    cycle_countdown <= 14'd0;

                counting <= 1'b1;
                done <= 1'b0;
                // count output handled combinationally
            end

            ST_WAIT_ACK: begin
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bits_count <= delay_bits_count;
                cycle_countdown <= 14'd0;
                counting <= 1'b0;
                done <= 1'b1;
                // count output don't care
            end

            default: begin
                state <= ST_PATTERN_DETECT;
                pattern_shift <= 4'd0;
                delay_reg <= 4'd0;
                delay_bits_count <= 3'd0;
                cycle_countdown <= 14'd0;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase

        // On transition from DELAY_LOAD to COUNTING: initialize countdown
        if (state == ST_DELAY_LOAD && next_state == ST_COUNTING) begin
            cycle_countdown <= (delay_reg + 1) * 14'd1000;
        end
    end
end

// Combinational logic for count output
// Approximate division by 1000 using shift by 10 (1024)
// Add 1023 for rounding (999 + 24 = 1023)
wire [13:0] adj_cycle_count = cycle_countdown + 14'd1023;
wire [3:0] rem_blocks_approx = adj_cycle_count[13:10]; // divide approx by 1024

always @(*) begin
    if (state == ST_COUNTING) begin
        // rem_blocks_approx ~ (cycle_countdown + 999)/1000
        // count = remaining 1000-cycle blocks = rem_blocks_approx - 1;
        // To prevent underflow and overflow:
        if (cycle_countdown == 14'd0) begin
            count = 4'd0;
        end else if (rem_blocks_approx == 0) begin
            count = delay_reg;
        end else if (rem_blocks_approx <= delay_reg + 1) begin
            count = (delay_reg + 1) - rem_blocks_approx;
        end else begin
            count = 4'd0;
        end
    end else begin
        count = 4'd0; // don't care outside counting
    end
end

endmodule