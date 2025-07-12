module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding: 3-bit binary states
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // matched "1101" (final detected, sticky)

    reg [2:0] state;

    // Next-state logic as combinational assign using case expression
    wire [2:0] next_state;
    assign next_state = (state == S4) ? S4 : // sticky final state, no further transitions
                        (state == S0) ? (data ? S1 : S0) :
                        (state == S1) ? (data ? S2 : S0) :
                        (state == S2) ? (data ? S2 : S3) :
                        (state == S3) ? (data ? S4 : S0) :
                        S0; // default fallback

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output asserted when in final detected state
    assign start_shifting = (state == S4);

endmodule