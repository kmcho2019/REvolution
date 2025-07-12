module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding
    localparam S0 = 5'b00001; // no match yet
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '11'
    localparam S3 = 5'b01000; // matched '110'
    localparam S4 = 5'b10000; // matched '1101' (final detected state)

    reg [4:0] state, next_state;

    // Combinational next-state logic (blocking assignments)
    always @(*) begin
        // Default hold current state to prevent latches
        next_state = state;

        case (1'b1) // priority encoding style for one-hot
            state[0]: // S0
                next_state = data ? S1 : S0;
            state[1]: // S1
                next_state = data ? S2 : S0;
            state[2]: // S2
                next_state = data ? S2 : S3;
            state[3]: // S3
                next_state = data ? S4 : S0;
            state[4]: // S4 - sticky final state
                next_state = S4;
            default:
                next_state = S0; // safety fallback
        endcase
    end

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output combinational logic - Moore style output
    assign start_shifting = state[4];

endmodule