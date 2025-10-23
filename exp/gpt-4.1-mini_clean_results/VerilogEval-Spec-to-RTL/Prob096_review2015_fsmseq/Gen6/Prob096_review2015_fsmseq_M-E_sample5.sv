module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot state encoding: each bit corresponds to one state
    // States: S0 (no match), S1 (matched '1'), S11 (matched "11"), S110 (matched "110"), S_FOUND (sequence found)
    localparam S0       = 5'b00001;
    localparam S1       = 5'b00010;
    localparam S11      = 5'b00100;
    localparam S110     = 5'b01000;
    localparam S_FOUND  = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            S0:      next_state = data ? S1     : S0;
            S1:      next_state = data ? S11    : S0;
            S11:     next_state = data ? S11    : S110;
            S110:    next_state = data ? S_FOUND: S0;
            S_FOUND: next_state = S_FOUND; // Remain here forever until reset
            default: next_state = S0;
        endcase
    end

    // State and output registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S_FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule