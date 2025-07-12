module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot encoding for FSM states (5 states)
    localparam S0 = 5'b00001; // no match
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched "11"
    localparam S3 = 5'b01000; // matched "110"
    localparam S4 = 5'b10000; // matched "1101" (final sticky)

    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (1'b1)
            state[0]: next_state = data ? S1 : S0;     // S0
            state[1]: next_state = data ? S2 : S0;     // S1
            state[2]: next_state = data ? S2 : S3;     // S2
            state[3]: next_state = data ? S4 : S0;     // S3
            state[4]: next_state = S4;                  // S4 (sticky)
            default:   next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output asserted in sticky final state S4
    assign start_shifting = state[4];

endmodule