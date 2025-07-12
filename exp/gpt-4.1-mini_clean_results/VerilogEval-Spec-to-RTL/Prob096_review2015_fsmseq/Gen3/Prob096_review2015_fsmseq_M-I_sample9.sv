module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam S0   = 4'b0001; // no match
    localparam S1   = 4'b0010; // matched '1'
    localparam S11  = 4'b0100; // matched '11'
    localparam S110 = 4'b1000; // matched '110'

    reg [3:0] state, next_state;

    always @(*) begin
        // Default assignments
        next_state = S0;
        start_shifting = start_shifting; // keep previous value unless reset or set
        case (state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S11  : S0;
            S11:  next_state = data ? S11  : S110;
            S110: next_state = data ? S1   : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential block to update state and output on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Sequence found when current state is S110 and data=1
            if ((state == S110) && data)
                start_shifting <= 1'b1;
            else
                start_shifting <= start_shifting; // hold
        end
    end

endmodule