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

    // One-hot state bits
    typedef enum logic [5:0] {
        S_SEARCH   = 6'b000001,  // searching for pattern
        S_SHIFT_0  = 6'b000010,  // shift cycle 0
        S_SHIFT_1  = 6'b000100,  // shift cycle 1
        S_SHIFT_2  = 6'b001000,  // shift cycle 2
        S_SHIFT_3  = 6'b010000,  // shift cycle 3
        S_COUNT    = 6'b100000,  // waiting counting done
        S_DONE     = 6'b000001   // reuse S_SEARCH for reset after ack (will assign explicitly)
    } state_t;

    reg [5:0] state, next_state;

    // Shift register to detect 1101 pattern serially in S_SEARCH state
    // 4 bits to hold last 4 serial data bits
    reg [3:0] pattern_sr;

    // Pattern we're looking for: 4'b1101
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic for state and pattern_sr
    always @(posedge clk) begin
        if (reset) begin
            state <= S_SEARCH;
            pattern_sr <= 4'b0000;
        end else begin
            state <= next_state;

            if (state == S_SEARCH) begin
                // Shift in data bit each clock during search
                pattern_sr <= {pattern_sr[2:0], data};
            end else begin
                // Freeze pattern_sr outside of search
                pattern_sr <= pattern_sr;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S_SEARCH: begin
                if (pattern_sr == PATTERN)
                    next_state = S_SHIFT_0;
                else
                    next_state = S_SEARCH;
            end
            S_SHIFT_0: next_state = S_SHIFT_1;
            S_SHIFT_1: next_state = S_SHIFT_2;
            S_SHIFT_2: next_state = S_SHIFT_3;
            S_SHIFT_3: next_state = S_COUNT;
            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end
            S_DONE: begin
                if (ack)
                    next_state = S_SEARCH;
                else
                    next_state = S_DONE;
            end
            default: next_state = S_SEARCH;
        endcase
    end

    // Outputs derived from state bits
    assign shift_ena = (state == S_SHIFT_0) ||
                       (state == S_SHIFT_1) ||
                       (state == S_SHIFT_2) ||
                       (state == S_SHIFT_3);

    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule