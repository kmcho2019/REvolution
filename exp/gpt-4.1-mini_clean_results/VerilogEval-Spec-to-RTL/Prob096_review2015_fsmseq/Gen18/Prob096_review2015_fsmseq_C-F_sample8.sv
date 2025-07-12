module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output wire start_shifting
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched "11"
        S3 = 3'd3, // matched "110"
        S4 = 3'd4; // matched "1101" (final sticky state)

    reg [2:0] state, next_state;
    wire ce; // clock enable to freeze state in final detected state

    // Combinational next_state logic using nested ternary operators for conciseness
    assign next_state = (state == S0) ? (data ? S1 : S0) :
                        (state == S1) ? (data ? S2 : S0) :
                        (state == S2) ? (data ? S2 : S3) :
                        (state == S3) ? (data ? S4 : S0) :
                        S4; // Remain in final state

    // Clock enable to freeze state updates when detected sequence (sticky state)
    assign ce = (state != S4);

    // State update: synchronous active-high reset and clock enable gating
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else if (ce)
            state <= next_state;
    end

    // Moore output, asserted when sequence detected and latched until reset
    assign start_shifting = (state == S4);

endmodule