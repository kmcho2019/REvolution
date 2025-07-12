module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// State definitions for readability
localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4,
           S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

// Output logic - active only in specific states
assign out1 = state[S8] | state[S9];
assign out2 = state[S7] | state[S9];

always @(*) begin
    next_state = 10'b0;  // Default to all zeros
    
    // Handle all possible current states in parallel
    if (state[S0]) begin
        next_state[in ? S1 : S0] = 1'b1;
    end
    else if (|state[4:1]) begin  // S1-S4 group
        next_state[in ? state + 1'b1 : S0] = 1'b1;
    end
    else if (state[S5]) begin
        next_state[in ? S6 : S8] = 1'b1;
    end
    else if (state[S6]) begin
        next_state[in ? S7 : S9] = 1'b1;
    end
    else if (state[S7]) begin
        next_state[in ? S7 : S0] = 1'b1;
    end
    else if (state[S8] | state[S9]) begin  // S8-S9 group
        next_state[in ? S1 : S0] = 1'b1;
    end
end

endmodule