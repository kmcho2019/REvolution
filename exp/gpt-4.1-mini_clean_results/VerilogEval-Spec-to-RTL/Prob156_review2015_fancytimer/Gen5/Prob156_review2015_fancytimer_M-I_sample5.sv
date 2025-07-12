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

// Timer counters:
// cycle_counter counts from 0 to 999 within a block (10 bits)
// block_counter counts down the number of 1000-cycle blocks remaining (4 bits)
reg [9:0] cycle_counter;  // counts 0..999 cycles inside a block
reg [3:0] block_counter;  // counts how many 1000-cycle blocks left, initialized to delay_reg+1

// Next state logic combinational
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
            if ((block_counter == 4'd0) && (cycle_counter == 10'd999))
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
        state <= ST_PATTERN_DETECT;
        pattern_shift <= 4'd0;
        delay_reg <= 4'd0;
        delay_bits_count <= 3'd0;
        cycle_counter <= 10'd0;
        block_counter <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0;
    end else begin
        state <= next_state;

        case(state)
            ST_PATTERN_DETECT: begin
                // Shift pattern_shift left and insert new data bit at LSB
                pattern_shift <= {pattern_shift[2:0], data};
                // Clear delay load registers
                delay_reg <= 4'd0;
                delay_bits_count <= 3'd0;
                // Clear counters
                cycle_counter <= 10'd0;
                block_counter <= 4'd0;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0; // don't care
            end

            ST_DELAY_LOAD: begin
                // Shift in data MSB first into delay_reg: shift left and insert bit at LSB
                delay_reg <= {delay_reg[2:0], data};
                delay_bits_count <= delay_bits_count + 1'b1;
                // Maintain pattern_shift (not used)
                pattern_shift <= pattern_shift;
                // Counters unchanged
                cycle_counter <= 10'd0;
                block_counter <= 4'd0;
                // Outputs
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
            end

            ST_COUNTING: begin
                // Hold pattern_shift, delay_reg, delay_bits_count stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bits_count <= delay_bits_count;

                counting <= 1'b1;
                done <= 1'b0;

                // cycle_counter counts 0..999
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    if (block_counter != 4'd0)
                        block_counter <= block_counter - 1'b1;
                end else begin
                    cycle_counter <= cycle_counter + 1'b1;
                    block_counter <= block_counter;
                end

                // Output count = blocks remaining (including current)
                // When cycle_counter counts within current block, count = block_counter
                // For example, if block_counter=delay+1, count=block_counter-1,
                // but problem states count = delay down to 0 for each 1000 cycles block,
                // so count = block_counter - 1
                // Because block_counter counts down to 0 (0 means last block done)
                // So:
                // count output = block_counter - 1 when counting, zero otherwise
                if (block_counter > 0)
                    count <= block_counter - 1'b1;
                else
                    count <= 4'd0;
            end

            ST_WAIT_ACK: begin
                // Keep all registers stable except outputs
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bits_count <= delay_bits_count;
                cycle_counter <= 10'd0;
                block_counter <= 4'd0;
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'd0; // don't care
            end

            default: begin
                state <= ST_PATTERN_DETECT;
                pattern_shift <= 4'd0;
                delay_reg <= 4'd0;
                delay_bits_count <= 3'd0;
                cycle_counter <= 10'd0;
                block_counter <= 4'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'd0;
            end
        endcase

        // On transition from DELAY_LOAD to COUNTING: initialize counters
        if (state == ST_DELAY_LOAD && next_state == ST_COUNTING) begin
            cycle_counter <= 10'd0;
            block_counter <= delay_reg + 1'b1; // total 1000-cycle blocks = delay+1
        end
    end
end

endmodule