module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot state encoding for faster and simpler logic
    localparam S0   = 4'b0001; // no match
    localparam S1   = 4'b0010; // matched '1'
    localparam S11  = 4'b0100; // matched '11'
    localparam S110 = 4'b1000; // matched '110'

    reg [3:0] state, next_state;

    // Next state logic combined with sequence detection in one combinational block
    always @(*) begin
        // Default stay in no match state
        next_state = S0;

        // Default output: sequence not found
        // The start_shifting output latch will be set in sequential logic

        case (state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S11  : S0;
            S11:  next_state = data ? S11  : S110;
            S110: next_state = data ? S1   : S0;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;

            // Detect sequence found on transition:
            // sequence "1101" is found when in S110 state and input data==1
            if (state == S110 && data == 1'b1)
                start_shifting <= 1'b1;
        end
    end

endmodule