module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (binary) to minimize area and flip-flops
    // 0: no match
    // 1: matched '1'
    // 2: matched "11"
    // 3: matched "110"
    // 4: matched "1101" (final sticky)
    reg [2:0] state, next_state;
    reg       ce; // clock enable to gate state updates after detection

    // Next state logic
    always @(*) begin
        case (state)
            3'd0: next_state = data ? 3'd1 : 3'd0;
            3'd1: next_state = data ? 3'd2 : 3'd0;
            3'd2: next_state = data ? 3'd2 : 3'd3;
            3'd3: next_state = data ? 3'd4 : 3'd0;
            3'd4: next_state = 3'd4; // sticky final state
            default: next_state = 3'd0;
        endcase
    end

    // Clock enable: disable updates when in final state to reduce toggling/power
    always @(*) begin
        ce = (state != 3'd4);
    end

    // State register with synchronous active-high reset and clock enable
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else if (ce)
            state <= next_state;
    end

    // Output asserted high in sticky final detected state
    assign start_shifting = (state == 3'd4);

endmodule