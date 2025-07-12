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

    // State encoding: 4 bits to cover search states (0-3), shift substates (4-7), count (8), done (9)
    localparam [3:0]
        SEARCH0 = 4'd0, // waiting for first '1'
        SEARCH1 = 4'd1, // matched '1'
        SEARCH2 = 4'd2, // matched '11'
        SEARCH3 = 4'd3, // matched '110'
        SHIFT0  = 4'd4, // shift cycle 0
        SHIFT1  = 4'd5, // shift cycle 1
        SHIFT2  = 4'd6, // shift cycle 2
        SHIFT3  = 4'd7, // shift cycle 3
        COUNT   = 4'd8, // waiting for counting done
        DONE    = 4'd9; // done, wait ack

    reg [3:0] state, next_state;

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            // Pattern detection 1101
            SEARCH0: next_state = (data) ? SEARCH1 : SEARCH0;
            SEARCH1: next_state = (data) ? SEARCH2 : SEARCH0;
            SEARCH2: next_state = (~data) ? SEARCH3 : SEARCH2;
            SEARCH3: next_state = (data) ? SHIFT0 : SEARCH0;

            // Shift four bits with shift_ena asserted for 4 clocks
            SHIFT0:  next_state = SHIFT1;
            SHIFT1:  next_state = SHIFT2;
            SHIFT2:  next_state = SHIFT3;
            SHIFT3:  next_state = COUNT;

            // Counting wait
            COUNT:   next_state = done_counting ? DONE : COUNT;

            // Done state waiting for ack
            DONE:    next_state = ack ? SEARCH0 : DONE;

            default: next_state = SEARCH0;
        endcase
    end

    // Moore outputs derived from state encoding
    assign shift_ena = (state >= SHIFT0) && (state <= SHIFT3);
    assign counting  = (state == COUNT);
    assign done      = (state == DONE);

endmodule