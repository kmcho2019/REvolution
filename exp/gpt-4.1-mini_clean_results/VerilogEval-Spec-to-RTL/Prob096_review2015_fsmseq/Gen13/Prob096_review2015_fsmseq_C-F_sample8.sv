module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding using localparam for clarity
    localparam [2:0]
        S0 = 3'b000, // no bits matched
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" (final detected state)

    // State register
    reg [2:0] state, next_state;

    // Synchronous state update with active-high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // latch final detected state indefinitely
            default: next_state = S0; // default to safe state
        endcase
    end

    // Output asserted when final detected state is reached and held
    assign start_shifting = (state == S4);

endmodule