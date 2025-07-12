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
    localparam S4 = 3'b100; // matched '1101' (final detected)

    reg [2:0] state, next_state;

    // Clock enable: disable updates once final state reached
    wire clk_en = ~(state == S4);

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4;
            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else if (clk_en)
            state <= next_state;
    end

    assign start_shifting = (state == S4);

endmodule