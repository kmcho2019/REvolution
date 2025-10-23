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

    // State transitions - optimized for common patterns
    next_state[0] = (~in & (|state[7:0])) |  // From S0-S7
                   (~in & (state[8] | state[9]));  // From S8,S9
    
    next_state[1] = in & (state[0] | state[8] | state[9]);
    next_state[2] = in & state[1];
    next_state[3] = in & state[2];
    next_state[4] = in & state[3];
    next_state[5] = in & state[4];
    next_state[6] = in & state[5];
    next_state[7] = in & (state[6] | state[7]);
    next_state[8] = ~in & state[5];
    next_state[9] = ~in & state[6];

    // Output generation - only active in S7-S9
    case (1'b1)
        state[7]: out2 = 1'b1;
        state[8]: out1 = 1'b1;
        state[9]: {out1, out2} = 2'b11;
        default: {out1, out2} = 2'b00;
    endcase
end

endmodule