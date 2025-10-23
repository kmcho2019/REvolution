module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Default assignments
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    // State transition logic
    if (|state[0:4]) begin  // Common case for S0-S4
        next_state[0] = ~in;
        if (state[0]) next_state[1] = in;
        if (state[1]) next_state[2] = in;
        if (state[2]) next_state[3] = in;
        if (state[3]) next_state[4] = in;
        if (state[4]) next_state[5] = in;
    end
    if (state[5]) begin  // S5
        next_state[8] = ~in;
        next_state[6] = in;
    end
    if (state[6]) begin  // S6
        next_state[9] = ~in;
        next_state[7] = in;
    end
    if (state[7]) begin  // S7
        next_state[0] = ~in;
        next_state[7] = in;
    end
    if (|state[8:9]) begin  // Common case for S8-S9
        next_state[0] = ~in;
        next_state[1] = in;
    end

    // Output generation (independent of next state)
    case (1'b1)
        state[7]: out2 = 1;
        state[8]: out1 = 1;
        state[9]: {out1, out2} = 2'b11;
        default: {out1, out2} = 2'b00;
    endcase
end

endmodule