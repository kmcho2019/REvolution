module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding
    // State bits: [A, B, C, D]
    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        next_state = 4'b0000;  // Default no states active

        case (1'b1)  // Priority encoding style for one-hot state detection
            state[0]: begin // State A
                if (in == 1'b0)
                    next_state = 4'b0001; // Stay in A
                else
                    next_state = 4'b0010; // Move to B
            end
            state[1]: begin // State B
                if (in == 1'b0)
                    next_state = 4'b0100; // Move to C
                else
                    next_state = 4'b0010; // Stay in B
            end
            state[2]: begin // State C
                if (in == 1'b0)
                    next_state = 4'b0001; // Move to A
                else
                    next_state = 4'b1000; // Move to D
            end
            state[3]: begin // State D
                if (in == 1'b0)
                    next_state = 4'b0100; // Move to C
                else
                    next_state = 4'b0010; // Move to B
            end
            default: begin
                // Default to state A if none active
                next_state = 4'b0001;
            end
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 4'b0001; // Reset to state A
        else
            state <= next_state;
    end

    // Output logic for Moore FSM (output = 1 only in state D)
    always @(*) begin
        out = state[3]; // D state bit
    end

endmodule