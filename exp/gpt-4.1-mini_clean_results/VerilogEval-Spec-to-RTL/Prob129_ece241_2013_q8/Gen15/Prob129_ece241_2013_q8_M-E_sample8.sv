module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // One-hot encoding: only one bit set per state
    localparam S_IDLE = 3'b001; // no bits matched yet, waiting for '1'
    localparam S_1    = 3'b010; // matched '1'
    localparam S_10   = 3'b100; // matched "10"

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        // Default to stay in current state (safe default)
        next_state = 3'b000;

        case(state)
            S_IDLE: begin
                if (x)
                    next_state = S_1;    // got '1', move to S_1
                else
                    next_state = S_IDLE; // stay in idle waiting for '1'
            end
            S_1: begin
                if (x)
                    next_state = S_1;    // '1' again, remain in S_1
                else
                    next_state = S_10;   // got '0', move to S_10
            end
            S_10: begin
                if (x)
                    next_state = S_1;    // '1' detected, sequence "101" found, back to S_1 to allow overlapping
                else
                    next_state = S_IDLE; // '0' breaks sequence, return to idle
            end
            default: next_state = S_IDLE; // safety fallback
        endcase
    end

    // Output logic: Mealy output asserted only when sequence ends with input x=1 in state S_10
    always @(*) begin
        z = (state == S_10) && (x == 1'b1);
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule