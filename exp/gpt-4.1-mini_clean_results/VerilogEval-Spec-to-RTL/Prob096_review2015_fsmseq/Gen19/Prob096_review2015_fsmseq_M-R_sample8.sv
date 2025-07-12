module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoded states (5 states)
    // Each bit corresponds to a state: S0 to S4
    reg [4:0] state, next_state;

    // State bit positions for readability
    localparam S0 = 5'b00001; // no bits matched
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched "11"
    localparam S3 = 5'b01000; // matched "110"
    localparam S4 = 5'b10000; // matched "1101" detected (sticky)

    // Sequential logic: update state on rising edge, synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic using one-hot encoding
    always @(*) begin
        // Default next state is hold current state
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
            state[4]: // S4 sticky final detected state
                next_state = S4;
            default:
                next_state = S0;
        endcase
    end

    // Output logic (Moore output): start_shifting is high when in S4 state
    assign start_shifting = state[4];

endmodule