module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // State encoding (lower value = higher water level)
    // 00: Above s2 (all sensors on)
    // 01: Between s2-s1 (s[1:0] on)
    // 10: Between s1-s0 (only s[0] on)
    // 11: Below s0 (no sensors on)
    reg [1:0] state;

    // Next state logic - direct from sensor patterns
    wire [1:0] next_state = 
        (s == 3'b111) ? 2'b00 :  // Above s2
        (s == 3'b011) ? 2'b01 :  // Between s2-s1
        (s == 3'b001) ? 2'b10 :  // Between s1-s0
                         2'b11;  // Below s0 (default)

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 2'b11;  // Reset to below s0
        else
            state <= next_state;
    end

    // Output logic - direct from state bits
    assign fr0 = state[1] | state[0];  // State 01, 10, or 11
    assign fr1 = state[1];             // State 10 or 11
    assign fr2 = &state;               // State 11 only (both bits set)

    // dfr asserts when water level is rising (next state < current state numerically)
    assign dfr = (next_state < state);

endmodule