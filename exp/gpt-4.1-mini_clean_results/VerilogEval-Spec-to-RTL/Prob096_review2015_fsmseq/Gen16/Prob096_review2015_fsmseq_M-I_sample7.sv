module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding
    localparam
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected state)

    reg [4:0] state, next_state;

    // Synchronous state update with active-high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic optimized for one-hot encoding and minimal combinational depth
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // hold final state
            default: next_state = S0;
        endcase
    end

    // Output combinational logic: asserted when in final detected state
    assign start_shifting = state[4]; // MSB corresponds to S4

endmodule