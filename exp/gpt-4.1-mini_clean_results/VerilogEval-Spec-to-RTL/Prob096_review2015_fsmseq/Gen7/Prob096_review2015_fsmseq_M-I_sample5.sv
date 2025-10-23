module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states
    localparam S0   = 4'b0001; // no match
    localparam S1   = 4'b0010; // matched '1'
    localparam S11  = 4'b0100; // matched '11'
    localparam S110 = 4'b1000; // matched '110'

    reg [3:0] state, next_state;

    // Next state logic with one-hot encoding
    always @(*) begin
        case (state)
            S0:    next_state = data ? S1   : S0;
            S1:    next_state = data ? S11  : S0;
            S11:   next_state = data ? S11  : S110;
            S110:  next_state = data ? S1   : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential block: state update and output generation
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Detect sequence when currently in S110 and input data==1 -> sequence "1101" detected
            if (state == S110 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule