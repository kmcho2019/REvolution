module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State definitions (one-hot encoding)
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    // Next state logic - optimized implementation
    always @(*) begin
        next_state = 4'b0000; // Default to all zeros (invalid state)
        
        if (state[0]) begin // State A
            next_state[0] = ~in;
            next_state[1] = in;
        end
        else if (state[1]) begin // State B
            next_state[1] = in;
            next_state[2] = ~in;
        end
        else if (state[2]) begin // State C
            next_state[0] = ~in;
            next_state[3] = in;
        end
        else if (state[3]) begin // State D
            next_state[1] = in;
            next_state[2] = ~in;
        end
    end

    // Output logic (Moore machine: output depends only on current state)
    assign out = state[3]; // Output is 1 only in state D

endmodule