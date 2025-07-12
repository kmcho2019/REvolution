module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam [4:0]
        S0 = 5'b00001, // no match
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched "11"
        S3 = 5'b01000, // matched "110"
        S4 = 5'b10000; // matched "1101" sticky final state

    reg [4:0] state, next_state;

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Set output high when entering S4 and hold it
            if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

    // Next-state combinational logic
    always @(*) begin
        // Default: remain in current state
        next_state = state;

        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S4 : S0;
            S4: next_state = S4; // sticky final state
            default: next_state = S0;
        endcase
    end

endmodule