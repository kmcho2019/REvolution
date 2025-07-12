module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding for 5 states
    localparam S0    = 5'b00001;  // no match
    localparam S1    = 5'b00010;  // matched '1'
    localparam S11   = 5'b00100;  // matched "11"
    localparam S110  = 5'b01000;  // matched "110"
    localparam S1101 = 5'b10000;  // matched "1101" (final detected)

    reg [4:0] state, next_state;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic for one-hot FSM
    always @(*) begin
        // Default no state asserted
        next_state = 5'b00000;

        case (1'b1) // synthesis parallel_case full_case
            state[0]: // S0
                next_state = data ? S1 : S0;
            state[1]: // S1
                next_state = data ? S11 : S0;
            state[2]: // S11
                next_state = data ? S11 : S110;
            state[3]: // S110
                next_state = data ? S1101 : S0;
            state[4]: // S1101, latch indefinitely
                next_state = S1101;
            default:
                next_state = S0;
        endcase
    end

    // Moore output: asserted only in detected state
    assign start_shifting = state[4];

endmodule