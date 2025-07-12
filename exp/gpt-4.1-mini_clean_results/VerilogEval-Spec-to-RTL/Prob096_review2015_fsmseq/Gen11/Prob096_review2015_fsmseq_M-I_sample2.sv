module TopModule (
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding
    localparam S0 = 3'b000; // no match
    localparam S1 = 3'b001; // matched '1'
    localparam S2 = 3'b010; // matched '11'
    localparam S3 = 3'b011; // matched '110'
    localparam S4 = 3'b100; // matched '1101' (final)

    reg [2:0] state, next_state;
    reg state_en; // enable signal for clock gating state register updates

    // Next state logic optimized with priority encoding style
    always @(*) begin
        if (state == S4) begin
            next_state = S4; // sticky final
        end else begin
            // Prioritized decoding of next state
            case (state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S4 : S0;
                default: next_state = S0;
            endcase
        end
    end

    // Enable signal disables state register updates once in final state, except on reset
    always @(*) begin
        if (reset)
            state_en = 1'b1;
        else
            state_en = (state != S4);
    end

    // Sequential state update with synchronous reset and internal clock gating enable
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else if (state_en)
            state <= next_state;
        // else retain current state, no update to reduce toggling and power
    end

    // Output combinationally assigned
    assign start_shifting = (state == S4);

endmodule