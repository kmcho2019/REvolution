module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding using 3-bit binary encoding for clarity and compactness
    localparam S0    = 3'd0;  // no match
    localparam S1    = 3'd1;  // matched '1'
    localparam S11   = 3'd2;  // matched "11"
    localparam S110  = 3'd3;  // matched "110"
    localparam S1101 = 3'd4;  // matched "1101" (final detected state)

    reg [2:0] state, next_state;

    // Synchronous state update with active high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0:    next_state = data ? S1    : S0;
            S1:    next_state = data ? S11   : S0;
            S11:   next_state = data ? S11   : S110;
            S110:  next_state = data ? S1101 : S0;
            S1101: next_state = S1101;  // stay in final state forever until reset
            default: next_state = S0;
        endcase
    end

    // Moore output logic: output is high only in the detected state
    assign start_shifting = (state == S1101);

endmodule