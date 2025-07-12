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

    // Main states (2 bits) for compact encoding
    localparam S_SEARCH = 2'b00;
    localparam S_SHIFT  = 2'b01;
    localparam S_COUNT  = 2'b10;
    localparam S_DONE   = 2'b11;

    reg [1:0] state, next_state;

    // Pattern detection: keep track of how many bits matched in 1101 sequence (4 states: 0 to 3)
    // We store pattern match progress in a separate 2-bit reg
    reg [1:0] pat_idx, next_pat_idx;

    // Shift counter: counts from 0 to 3 during SHIFT state
    reg [2:0] shift_cnt, next_shift_cnt;

    // Pattern bits: 1 1 0 1 at indexes 0..3
    function automatic bit pat_bit(input [1:0] idx);
        pat_bit = (idx == 2'd0 || idx == 2'd1 || idx == 2'd3) ? 1'b1 : 1'b0;
    endfunction

    // Pattern detection logic: on each clock when in SEARCH state, advance pat_idx if input matches pattern
    // If mismatch, reset or partially match to earlier progress (overlapping)
    // Using a simple approach of matching 1101 with state updates

    always @(*) begin
        // Default next values same as current
        next_state = state;
        next_pat_idx = pat_idx;
        next_shift_cnt = shift_cnt;

        case (state)
            S_SEARCH: begin
                // Update pat_idx depending on data input and current pat_idx
                if (data == pat_bit(pat_idx)) begin
                    // Correct bit matched, advance pat_idx
                    if (pat_idx == 2'd3) begin
                        // Full pattern matched, move to SHIFT and reset counters
                        next_state = S_SHIFT;
                        next_pat_idx = 2'd0;
                        next_shift_cnt = 3'd0;
                    end else begin
                        // Partial match continues
                        next_pat_idx = pat_idx + 2'd1;
                    end
                end else begin
                    // Mismatch: reset pat_idx but consider overlapping partial matches
                    // For pattern 1101, overlapping prefix can be 1 or 11
                    // Check if current data == '1' to restart pattern at idx=1 or 0
                    if (data == 1'b1) begin
                        // Check if second bit matches to jump to idx=1 (matched first '1')
                        // The pattern is 1101, so first two bits are '1','1'
                        // If data=1, restart pat_idx at 1, else 0
                        next_pat_idx = 2'd1;
                    end else begin
                        next_pat_idx = 2'd0;
                    end
                end
            end

            S_SHIFT: begin
                // During SHIFT, increment shift counter until 4 bits shifted
                if (shift_cnt == 3'd3) begin
                    next_state = S_COUNT;
                end else begin
                    next_shift_cnt = shift_cnt + 3'd1;
                end
            end

            S_COUNT: begin
                if (done_counting) begin
                    next_state = S_DONE;
                end
            end

            S_DONE: begin
                if (ack) begin
                    next_state = S_SEARCH;
                    next_pat_idx = 2'd0;
                    next_shift_cnt = 3'd0;
                end
            end
        endcase
    end

    // Sequential logic for state, pattern index, and shift counter with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pat_idx <= 2'd0;
            shift_cnt <= 3'd0;
        end else begin
            state <= next_state;
            pat_idx <= next_pat_idx;
            shift_cnt <= next_shift_cnt;
        end
    end

    // Outputs derived combinationally
    assign shift_ena = (state == S_SHIFT);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule