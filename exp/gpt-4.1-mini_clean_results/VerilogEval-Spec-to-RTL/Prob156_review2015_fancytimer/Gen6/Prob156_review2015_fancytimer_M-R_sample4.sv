module TopModule (
    input  wire       clk,
    input  wire       reset,    // synchronous active high reset
    input  wire       data,     // serial data input
    output wire [3:0] count,    // remaining 1000-cycle blocks output
    output wire       counting, // high while counting
    output wire       done,     // high when timer expired, waiting for ack
    input  wire       ack       // acknowledge input
);

// FSM states
localparam IDLE       = 3'd0; // searching for pattern
localparam DELAY_LOAD = 3'd1; // shifting in 4 delay bits MSB first
localparam COUNTING   = 3'd2; // counting down cycles
localparam DONE_WAIT  = 3'd3; // done asserted, waiting for ack

reg [2:0] state, next_state;

// Shift register for detecting pattern 1101
reg [3:0] pattern_shift;

// Register for delay value
reg [3:0] delay_reg;
reg [2:0] delay_bit_count; // counts 0..4 bits shifted in

// 14-bit down counter for total cycles left (max 16*1000=16000 < 2^14)
reg [13:0] cycle_countdown;

// State machine sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_shift <= 4'd0;
        delay_reg <= 4'd0;
        delay_bit_count <= 3'd0;
        cycle_countdown <= 14'd0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                // Shift pattern only in IDLE state to detect 1101
                pattern_shift <= {pattern_shift[2:0], data};
                // Clear delay registers for new loading
                delay_reg <= 4'd0;
                delay_bit_count <= 3'd0;
                cycle_countdown <= 14'd0; // no counting in IDLE
            end

            DELAY_LOAD: begin
                // Shift in delay bits MSB first: shift left by 1 and insert data at LSB
                delay_reg <= {delay_reg[2:0], data};
                delay_bit_count <= delay_bit_count + 1'b1;
                // pattern_shift stays unchanged
                pattern_shift <= pattern_shift;
                cycle_countdown <= 14'd0;
            end

            COUNTING: begin
                // Hold pattern and delay stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bit_count <= delay_bit_count;

                // Decrement cycle countdown if not zero
                if (cycle_countdown != 0)
                    cycle_countdown <= cycle_countdown - 14'd1;
                else
                    cycle_countdown <= 14'd0;
            end

            DONE_WAIT: begin
                // Hold all stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bit_count <= delay_bit_count;
                cycle_countdown <= 14'd0;
            end

            default: begin
                // Should never happen; reset defaults
                pattern_shift <= 4'd0;
                delay_reg <= 4'd0;
                delay_bit_count <= 3'd0;
                cycle_countdown <= 14'd0;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if (pattern_shift == 4'b1101)
                next_state = DELAY_LOAD;
            else
                next_state = IDLE;
        end

        DELAY_LOAD: begin
            if (delay_bit_count == 3'd4)
                next_state = COUNTING;
            else
                next_state = DELAY_LOAD;
        end

        COUNTING: begin
            if (cycle_countdown == 14'd0)
                next_state = DONE_WAIT;
            else
                next_state = COUNTING;
        end

        DONE_WAIT: begin
            if (ack)
                next_state = IDLE;
            else
                next_state = DONE_WAIT;
        end

        default: next_state = IDLE;
    endcase
end

// Initialize cycle_countdown at the start of counting state (on transition)
reg state_was_counting;

always @(posedge clk) begin
    if (reset) begin
        state_was_counting <= 1'b0;
    end else begin
        state_was_counting <= (state == COUNTING);
        // On entering COUNTING from DELAY_LOAD, initialize cycle_countdown
        if ((state == DELAY_LOAD) && (next_state == COUNTING)) begin
            // Calculate cycles = (delay_reg + 1)*1000
            // 1000*X = X*1000 = (X * 1024) - (X * 24)
            // We'll use direct multiplication here since delay_reg max=15
            // Use addition and shifts:
            // 1000 * X =  (X << 10) - (X << 4) - (X << 3) - (X << 1)
            // = X*1024 - X*16 - X*8 - X*2 = X*1024 - X*26 =  X*998 (close)
            // We'll use (delay_reg+1)*1000 = (delay_reg+1)*1000 literal
            
            // For simplicity and since 14 bits is small, use direct multiplication by 1000
            cycle_countdown <= (delay_reg + 1) * 14'd1000;
        end
    end
end

// counting and done signals
assign counting = (state == COUNTING);
assign done = (state == DONE_WAIT);

// Output count: remaining 1000-cycle blocks during counting
// count = (cycle_countdown + 999)/1000 - 1, clipped to [0..delay_reg]
// We can implement this with a combinational function.

reg [3:0] count_reg;

integer i;
reg [13:0] temp_count;
reg [3:0] blocks;

always @(*) begin
    if (state == COUNTING) begin
        temp_count = cycle_countdown + 14'd999; // add 999 for ceil div
        blocks = 0;
        // Subtract 1000 repeatedly (up to max 16 times) to find how many 1000s fit
        for (i = 0; i < 16; i = i+1) begin
            if (temp_count >= 14'd1000)
                temp_count = temp_count - 14'd1000;
            else
                break;
            blocks = blocks + 1;
        end
        if (blocks > 0)
            count_reg = blocks - 1;
        else
            count_reg = delay_reg; // edge case at start
        // Clamp count_reg to delay_reg max (should not exceed)
        if (count_reg > delay_reg)
            count_reg = delay_reg;
    end else begin
        count_reg = 4'bxxxx; // don't care when not counting
    end
end

assign count = count_reg;

endmodule