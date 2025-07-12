module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding for clarity and timing efficiency
    localparam [4:0]
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected)

    reg [4:0] state, next_state;

    // Synchronous active-high reset, state register
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic with default next_state to current state
    always @(*) begin
        next_state = state; // hold state by default

        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // sticky final state
            default: next_state = S0; // safe fallback
        endcase
    end

    // Moore output: start_shifting asserted in detected state S4
    assign start_shifting = (state == S4);

endmodule