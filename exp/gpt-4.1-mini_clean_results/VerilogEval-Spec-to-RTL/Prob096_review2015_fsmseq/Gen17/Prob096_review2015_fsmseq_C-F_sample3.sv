module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // State encoding for FSM detecting sequence "1101"
    localparam [2:0]
        S0 = 3'b000, // no bits matched yet
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" (final detected state)

    reg [2:0] state, next_state;

    // Sequential logic: state updates with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: determine next state based on current state and input data
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // Sticky final state to hold output high
            default: next_state = S0; // Defensive default to initial state
        endcase
    end

    // Output logic: start_shifting asserted when sequence "1101" is detected (state S4)
    assign start_shifting = (state == S4);

endmodule