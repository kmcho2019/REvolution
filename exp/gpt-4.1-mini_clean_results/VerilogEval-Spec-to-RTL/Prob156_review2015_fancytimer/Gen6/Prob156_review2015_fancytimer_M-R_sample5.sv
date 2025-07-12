module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active high reset
    input  wire       data,     // serial data input
    output wire [3:0] count,    // remaining time blocks output
    output wire       counting, // high while counting
    output wire       done,     // high when timer expired, waiting for ack
    input  wire       ack       // acknowledge input
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam DELAY_LOAD = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register to detect start pattern 1101
    reg [3:0] pattern_shift;

    // Delay register (4 bits), MSB first
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts bits received in DELAY_LOAD (0 to 4)

    // Counters for timing:
    // A 10-bit counter counts clock cycles within each 1000-cycle block (0 to 999)
    reg [9:0] cycle_1000_counter;

    // A 4-bit counter counts remaining blocks (delay down to 0)
    reg [3:0] block_counter;

    // Sequential logic: state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_received <= 3'd0;
            cycle_1000_counter <= 10'd0;
            block_counter <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    // Shift in serial data for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_reg <= 4'd0;
                    delay_bits_received <= 3'd0;
                    cycle_1000_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                DELAY_LOAD: begin
                    // Shift in delay bits MSB first: shift left and insert new bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;
                    // pattern_shift unchanged
                    pattern_shift <= pattern_shift;
                    // counters unchanged
                    cycle_1000_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // hold pattern_shift
                    delay_reg <= delay_reg;         // hold delay_reg
                    delay_bits_received <= delay_bits_received;
                    if (cycle_1000_counter == 10'd0) begin
                        // Starting a new 1000-cycle block or at first cycle
                        cycle_1000_counter <= 10'd999;
                        if (block_counter != 0)
                            block_counter <= block_counter - 1'b1;
                    end else begin
                        cycle_1000_counter <= cycle_1000_counter - 1'b1;
                        block_counter <= block_counter; // hold
                    end
                end

                DONE: begin
                    // Hold all registers stable
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_received <= delay_bits_received;
                    cycle_1000_counter <= 10'd0;
                    block_counter <= 4'd0;
                end

                default: begin
                    // Default safe reset
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_received <= 3'd0;
                    cycle_1000_counter <= 10'd0;
                    block_counter <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (pattern_shift == 4'b1101) begin
                    next_state = DELAY_LOAD;
                end
            end

            DELAY_LOAD: begin
                if (delay_bits_received == 3'd4) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // Countdown logic: Done when block_counter == 0 and cycle_1000_counter == 0 (i.e. last cycle done)
                if ((block_counter == 0) && (cycle_1000_counter == 10'd0)) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs:

    // counting is high only in COUNTING state
    assign counting = (state == COUNTING);

    // done is high only in DONE state
    assign done = (state == DONE);

    // count = remaining blocks during counting, don't care otherwise
    // While counting: count = block_counter, except for first cycle of each block where cycle_1000_counter == 999,
    // block_counter is just decremented in that clock so use block_counter + 1 for output during cycle_1000_counter==999 (except when block_counter==0)
    // But it's simpler to just output block_counter + 1 except when block_counter==0 (last block).
    // Instead, output block_counter + 1 when cycle_1000_counter > 0 (means blocks remaining),
    // when cycle_1000_counter==0 (last cycle of block), output block_counter.
    // But in our logic, block_counter is decremented only when cycle_1000_counter==0.
    // So we can output: if counting, count = block_counter + (cycle_1000_counter != 10'd999 ? 1 : 0)
    // However, the simplest is to output count = block_counter + (cycle_1000_counter == 10'd999 ? 0 : 1), with care for zero case.
    // To keep correct semantics, just output count = block_counter + (cycle_1000_counter != 10'd999 && block_counter != 0 ? 1 : 0)
    //
    // To avoid complexity, output just block_counter + 1 when counting unless block_counter == 0 (last block), where count=0.
    // block_counter counts down from delay to 0, so when block_counter=delay means full remaining blocks,
    // count output corresponds to remaining blocks including the current one.
    //
    // This is equivalent to: count = (block_counter == 0) ? 4'd0 : block_counter + 1;

    assign count = (state == COUNTING) ? (block_counter == 0 ? 4'd0 : block_counter + 4'd1) : 4'd0;

endmodule