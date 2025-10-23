module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Transition matrix: for each state (row), shows next state for in=0 and in=1
parameter [9:0] TRANSITION_MATRIX [0:9][0:1] = '{
    '{10'b0000000001, 10'b0000000010}, // S0
    '{10'b0000000001, 10'b0000000100}, // S1
    '{10'b0000000001, 10'b0000001000}, // S2
    '{10'b0000000001, 10'b0000010000}, // S3
    '{10'b0000000001, 10'b0000100000}, // S4
    '{10'b0001000000, 10'b0000010000}, // S5
    '{10'b0010000000, 10'b0000001000}, // S6
    '{10'b0000000001, 10'b0000001000}, // S7
    '{10'b0000000001, 10'b0000000010}, // S8
    '{10'b0000000001, 10'b0000000010}  // S9
};

// Output patterns: {out1, out2} for each state
parameter [1:0] OUTPUT_PATTERNS [0:9] = '{
    2'b00,  // S0
    2'b00,  // S1
    2'b00,  // S2
    2'b00,  // S3
    2'b00,  // S4
    2'b00,  // S5
    2'b00,  // S6
    2'b01,  // S7
    2'b10,  // S8
    2'b11   // S9
};

integer i;
always @(*) begin
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;
    
    // Compute next_state by OR-ing all possible transitions
    for (i = 0; i < 10; i = i + 1) begin
        if (state[i]) begin
            next_state = next_state | TRANSITION_MATRIX[i][in];
            {out1, out2} = OUTPUT_PATTERNS[i];
        end
    end
end

endmodule