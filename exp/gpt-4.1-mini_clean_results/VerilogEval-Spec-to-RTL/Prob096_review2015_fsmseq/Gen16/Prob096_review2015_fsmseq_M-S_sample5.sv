module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // matched '1'
    localparam S2 = 3'd2; // matched '11'
    localparam S3 = 3'd3; // matched '110'
    localparam S4 = 3'd4; // matched '1101' (final sticky)

    reg [2:0] state, next_state;

    // Next state logic
    always @* begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;  // sticky final state
            default: next_state = S0;
        endcase
    end

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output assertion when in final state
    assign start_shifting = (state == S4);

endmodule