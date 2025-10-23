module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Optimized output logic
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    // Initialize all bits to 0
    next_state = 10'b0;
    
    // Handle S0 transitions
    if (state[0]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
    
    // Handle S1-S4 group with shared logic
    if (|state[4:1]) begin
        if (~in) next_state[0] = 1'b1;
        else begin
            case (1'b1)
                state[1]: next_state[2] = 1'b1;
                state[2]: next_state[3] = 1'b1;
                state[3]: next_state[4] = 1'b1;
                state[4]: next_state[5] = 1'b1;
            endcase
        end
    end
    
    // Handle S5
    if (state[5]) begin
        next_state[8] = ~in;
        next_state[6] = in;
    end
    
    // Handle S6
    if (state[6]) begin
        next_state[9] = ~in;
        next_state[7] = in;
    end
    
    // Handle S7
    if (state[7]) begin
        next_state[0] = ~in;
        next_state[7] = in;
    end
    
    // Handle S8-S9 group
    if (|state[9:8]) begin
        next_state[0] = ~in;
        next_state[1] = in;
    end
end

endmodule