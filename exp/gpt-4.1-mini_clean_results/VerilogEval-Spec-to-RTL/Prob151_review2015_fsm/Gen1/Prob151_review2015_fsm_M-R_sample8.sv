module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output wire shift_ena,
    output wire counting,
    output wire done
);

    // One-hot state encoding
    localparam S_SEARCH = 4'b0001;
    localparam S_SHIFT  = 4'b0010;
    localparam S_COUNT  = 4'b0100;
    localparam S_DONE   = 4'b1000;

    reg [3:0] state, next_state;

    // Shift register for pattern detection (updated every cycle)
    reg [3:0] pattern_shift_reg;

    // Shift counter for exactly 4 cycles during S_SHIFT
    reg [2:0] shift_counter;

    // Pattern to detect: 1101
    localparam [3:0] PATTERN = 4'b1101;

    // Pattern shift register update (serial input shift-in)
    always @(posedge clk) begin
        if (reset)
            pattern_shift_reg <= 4'b0;
        else
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH;
        else
            state <= next_state;
    end

    // Shift counter update
    always @(posedge clk) begin
        if (reset)
            shift_counter <= 3'd0;
        else if (state == S_SHIFT)
            shift_counter <= shift_counter + 3'd1;
        else
            shift_counter <= 3'd0;
    end

    // Next state combinational logic
    always @(*) begin
        // Default to hold current state
        next_state = state;

        case (state)
            S_SEARCH: begin
                // Detect pattern only when shift_reg matches and proceed to shift state
                if (pattern_shift_reg == PATTERN)
                    next_state = S_SHIFT;
            end

            S_SHIFT: begin
                // After 4 cycles of shifting, move to counting state
                if (shift_counter == 3'd3)
                    next_state = S_COUNT;
            end

            S_COUNT: begin
                // Wait for done_counting signal
                if (done_counting)
                    next_state = S_DONE;
            end

            S_DONE: begin
                // Wait for ack before returning to search state
                if (ack)
                    next_state = S_SEARCH;
            end

            default: next_state = S_SEARCH;
        endcase
    end

    // Output signals registered and derived from state register
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule