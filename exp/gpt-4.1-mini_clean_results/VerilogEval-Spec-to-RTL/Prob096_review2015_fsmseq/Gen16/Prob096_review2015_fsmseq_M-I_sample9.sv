module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoding for 5 states: S0-S4
    localparam
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" (final detected state)

    reg [4:0] state, next_state;

    // Synchronous reset and state register update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic (one-hot FSM) - minimal combinational logic
    always @(*) begin
        // Default next state: hold current state (important for S4)
        next_state = state;

        case (1'b1)
            state[0]: // S0
                next_state = data ? S1 : S0;
            state[1]: // S1
                next_state = data ? S2 : S0;
            state[2]: // S2
                next_state = data ? S2 : S3;
            state[3]: // S3
                next_state = data ? S4 : S0;
            state[4]: // S4 (final detected)
                next_state = S4; // latch indefinitely
            default:
                next_state = S0;
        endcase
    end

    assign start_shifting = state[4];

endmodule