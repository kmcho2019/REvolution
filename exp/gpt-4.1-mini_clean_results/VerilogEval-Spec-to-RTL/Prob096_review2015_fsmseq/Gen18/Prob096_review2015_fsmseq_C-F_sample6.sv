module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoding of states for minimal combinational decoding
    localparam [4:0]
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected)

    reg [4:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic using a case statement for clarity and synthesis optimization
    always @(*) begin
        next_state = state;  // default to hold current state (sticky state for S4)
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // Remain in detected state indefinitely
            default: next_state = S0; // Safe default to reset on invalid state
        endcase
    end

    // Moore output - asserted when detected sequence (S4) is reached
    assign start_shifting = (state == S4);

endmodule