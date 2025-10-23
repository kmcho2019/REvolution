module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding with localparams for clarity and binary efficiency
    localparam [2:0]
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" sticky final state

    reg [2:0] state, next_state;

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic with default and a case statement
    always @(*) begin
        next_state = state;  // default hold state
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // sticky final state, no leaving
            default: next_state = S0; // safe fallback (should never occur)
        endcase
    end

    // Output asserted in sticky final state
    assign start_shifting = (state == S4);

endmodule