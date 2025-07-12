module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - direct continuous assignments
assign out1 = |state[9:8];  // S8 or S9
assign out2 = |state[9:7] & (state[7] | state[9]);  // S7 or S9 (optimized)

// Common signals
wire in_n = ~in;
wire any_S0_S4 = |state[4:0];
wire any_S8_S9 = |state[9:8];

always @(*) begin
    next_state = 10'b0;
    
    // Handle S0-S4 transitions
    if (any_S0_S4) begin
        next_state[0] = in_n;
        case (1'b1)
            state[0]: next_state[1] = in;
            state[1]: next_state[2] = in;
            state[2]: next_state[3] = in;
            state[3]: next_state[4] = in;
            state[4]: next_state[5] = in;
        endcase
    end
    
    // Handle S5-S6 transitions
    if (state[5]) begin
        next_state[8] = in_n;
        next_state[6] = in;
    end
    if (state[6]) begin
        next_state[9] = in_n;
        next_state[7] = in;
    end
    
    // Handle S7 transition
    if (state[7]) begin
        next_state[0] = next_state[0] | in_n;
        next_state[7] = in;
    end
    
    // Handle S8-S9 transitions
    if (any_S8_S9) begin
        next_state[0] = next_state[0] | in_n;
        next_state[1] = next_state[1] | in;
    end
end

endmodule