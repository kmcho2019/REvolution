module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic - continuous assignments
assign out1 = state[8] | state[9];  // S8 or S9
assign out2 = state[7] | state[9];  // S7 or S9

always @(*) begin
    next_state = 10'b0;
    
    // Group states with similar transitions
    if (|state[4:0]) begin // S0-S4
        next_state[0] = ~in;
        if (in) begin
            case (1'b1)
                state[0]: next_state[1] = 1'b1;
                state[1]: next_state[2] = 1'b1;
                state[2]: next_state[3] = 1'b1;
                state[3]: next_state[4] = 1'b1;
                state[4]: next_state[5] = 1'b1;
            endcase
        end
    end
    
    // Handle remaining states individually
    if (state[5]) begin // S5
        next_state[in ? 6 : 8] = 1'b1;
    end
    if (state[6]) begin // S6
        next_state[in ? 7 : 9] = 1'b1;
    end
    if (state[7]) begin // S7
        next_state[in ? 7 : 0] = 1'b1;
    end
    if (|state[9:8]) begin // S8-S9
        next_state[in ? 1 : 0] = 1'b1;
    end
end

endmodule