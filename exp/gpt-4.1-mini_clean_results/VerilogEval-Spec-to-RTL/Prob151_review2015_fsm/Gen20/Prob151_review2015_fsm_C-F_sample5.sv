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

    // State encoding: pattern detection states + shift substates + counting + done
    typedef enum logic [3:0] {
        S_SEARCH0 = 4'd0, // waiting for first '1'
        S_SEARCH1 = 4'd1, // matched '1'
        S_SEARCH2 = 4'd2, // matched '11'
        S_SEARCH3 = 4'd3, // matched '110'
        S_SHIFT0  = 4'd4, // shift bit 0
        S_SHIFT1  = 4'd5, // shift bit 1
        S_SHIFT2  = 4'd6, // shift bit 2
        S_SHIFT3  = 4'd7, // shift bit 3
        S_COUNT   = 4'd8, // waiting for counting done
        S_DONE    = 4'd9  // done, waiting for ack
    } state_t;

    state_t state, next_state;

    // Sequential logic: state register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH0;
        else
            state <= next_state;
    end

    // Combinational next-state logic based on current state and inputs
    always @(*) begin
        case (state)
            // Pattern detection: sequence 1101 on 'data' input
            S_SEARCH0: next_state = (data) ? S_SEARCH1 : S_SEARCH0;
            S_SEARCH1: next_state = (data) ? S_SEARCH2 : S_SEARCH0;
            S_SEARCH2: next_state = (~data) ? S_SEARCH3 : S_SEARCH2;
            S_SEARCH3: next_state = (data) ? S_SHIFT0 : S_SEARCH0;

            // Shift 4 bits, one per state, then move to counting
            S_SHIFT0:  next_state = S_SHIFT1;
            S_SHIFT1:  next_state = S_SHIFT2;
            S_SHIFT2:  next_state = S_SHIFT3;
            S_SHIFT3:  next_state = S_COUNT;

            // Wait for done_counting signal
            S_COUNT:   next_state = (done_counting) ? S_DONE : S_COUNT;

            // Assert done and wait for ack to reset to pattern search
            S_DONE:    next_state = (ack) ? S_SEARCH0 : S_DONE;

            default:   next_state = S_SEARCH0;
        endcase
    end

    // Outputs assigned from state encoding (Moore machine)
    assign shift_ena = (state >= S_SHIFT0) && (state <= S_SHIFT3);
    assign counting  = (state == S_COUNT);
    assign done      = (state == S_DONE);

endmodule