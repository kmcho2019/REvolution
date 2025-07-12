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

    // FSM states enumeration
    typedef enum logic [2:0] {
        S_SEARCH = 3'd0,   // Pattern detection/search state
        S_SHIFT  = 3'd1,   // Shift in 4 bits
        S_COUNT  = 3'd2,   // Counting in progress
        S_DONE   = 3'd3    // Done, wait for ack
    } state_t;

    state_t state, next_state;

    // For pattern detection, hold last 4 bits of data input to detect 1101
    // Implement pattern detection with a shift register register of 4 bits
    reg [3:0] pattern_shift_reg;

    // Shift counter for counting 4 shift cycles
    reg [2:0] shift_count; // needs only 3 bits since counting to 4

    // Pattern detection logic: update pattern_shift_reg every cycle in SEARCH or SHIFT states
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift_reg <= 4'b0000;
        end else if (state == S_SEARCH || state == S_SHIFT) begin
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};
        end
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH;
        else
            state <= next_state;
    end

    // Shift count register for counting 4 cycles in SHIFT state
    always @(posedge clk) begin
        if (reset || state != S_SHIFT)
            shift_count <= 3'd0;
        else if (state == S_SHIFT)
            shift_count <= shift_count + 3'd1;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            S_SEARCH: begin
                // Detect pattern 1101: bits [3:0] == 4'b1101
                if (pattern_shift_reg == 4'b1101)
                    next_state = S_SHIFT;
            end
            S_SHIFT: begin
                if (shift_count == 3'd3) // completed 4 shift cycles (0..3)
                    next_state = S_COUNT;
            end
            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
            end
            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    // Outputs as combinational based on state
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule