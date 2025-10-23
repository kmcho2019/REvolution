module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding: 2-bit for 4 states
    localparam S0   = 2'd0; // no match
    localparam S1   = 2'd1; // matched '1'
    localparam S11  = 2'd2; // matched '11'
    localparam S110 = 2'd3; // matched '110'

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            S0:    next_state = data ? S1 : S0;
            S1:    next_state = data ? S11 : S0;
            S11:   next_state = data ? S11 : S110;
            S110:  next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S110 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule