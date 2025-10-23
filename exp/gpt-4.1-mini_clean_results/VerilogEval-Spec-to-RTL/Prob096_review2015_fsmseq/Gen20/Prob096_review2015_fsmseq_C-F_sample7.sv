module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // Binary encoded states with descriptive localparams
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // matched "1101" final sticky state

    reg [2:0] state, next_state;

    // Combinational next-state logic using case statement without default hold to reduce toggling
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;  // sticky final state
            default: next_state = S0; // safe fallback
        endcase
    end

    // Synchronous state update with active-high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output asserted when in the sticky final state
    assign start_shifting = (state == S4);

endmodule