module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding: minimal 3-bit binary
    localparam [2:0]
        S0 = 3'b000, // no match
        S1 = 3'b001, // matched '1'
        S2 = 3'b010, // matched "11"
        S3 = 3'b011, // matched "110"
        S4 = 3'b100; // matched "1101" sticky detected state

    reg [2:0] state, next_state;

    // Synchronous active-high reset, state update on posedge clk
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic: combinational with blocking assignment and case statement
    always @(*) begin
        next_state = state; // default hold current state (sticky for S4)
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // remain in detected sticky state
            default: next_state = S0; // safe fallback
        endcase
    end

    // Moore output logic: high in final detected state
    assign start_shifting = (state == S4);

endmodule