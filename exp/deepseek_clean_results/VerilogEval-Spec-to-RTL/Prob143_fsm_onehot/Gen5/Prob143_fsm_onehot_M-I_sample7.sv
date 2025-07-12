module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - simple continuous assignments
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7] & state[7]; // S7 or S9 (more efficient encoding)

// Precompute common conditions
wire not_in = ~in;

always @(*) begin
    next_state = 10'b0;
    
    // Handle all states in parallel using casez for more efficient decoding
    casez (state)
        10'b???????1??: begin // S0-S9
            // Common transition to S0 for most states
            next_state[0] = not_in;
            
            // State-specific transitions
            if (state[0]) next_state[1] = in;  // S0
            if (state[1]) next_state[2] = in;  // S1
            if (state[2]) next_state[3] = in;  // S2
            if (state[3]) next_state[4] = in;  // S3
            if (state[4]) next_state[5] = in;  // S4
            if (state[5]) begin                // S5
                next_state[8] = not_in;
                next_state[6] = in;
            end
            if (state[6]) begin                // S6
                next_state[9] = not_in;
                next_state[7] = in;
            end
            if (state[7]) next_state[7] = in;  // S7
            if (|state[9:8]) next_state[1] = next_state[1] | in; // S8/S9
        end
        default: next_state[0] = 1'b1; // Default to S0
    endcase
end

endmodule