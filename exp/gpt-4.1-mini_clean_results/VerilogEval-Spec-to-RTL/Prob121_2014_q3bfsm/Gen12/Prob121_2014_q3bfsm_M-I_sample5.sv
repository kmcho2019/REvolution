module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding: Each state has one bit set
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic: combinational, blocking assignments
    // Using direct boolean logic for one-hot next state transitions
    always @(*) begin
        // Default no change to avoid inferred latches
        next_state = 5'b00000;

        if (state == S0)
            next_state = x ? S1 : S0;
        else if (state == S1)
            next_state = x ? S4 : S1;
        else if (state == S2)
            next_state = x ? S1 : S2;
        else if (state == S3)
            next_state = x ? S2 : S1;
        else if (state == S4)
            next_state = x ? S4 : S3;
        else
            next_state = S0; // Safe default for invalid state
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: combinational based on one-hot states
    always @(*) begin
        // z=1 for states S3 and S4 only
        z = (state == S3) || (state == S4);
    end

endmodule