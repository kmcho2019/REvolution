module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Outputs only depend on current state
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

always @(*) begin
    next_state = 10'b0;
    
    // Handle state transitions
    if (|state[4:0]) begin // S0-S4
        next_state[0] = ~in;
        if (in) begin
            case (1'b1)
                state[0]: next_state[1] = 1;
                state[1]: next_state[2] = 1;
                state[2]: next_state[3] = 1;
                state[3]: next_state[4] = 1;
                state[4]: next_state[5] = 1;
            endcase
        end
    end
    else if (state[5]) begin // S5
        next_state[in ? 6 : 8] = 1;
    end
    else if (state[6]) begin // S6
        next_state[in ? 7 : 9] = 1;
    end
    else if (state[7]) begin // S7
        next_state[in ? 7 : 0] = 1;
    end
    else if (state[8] | state[9]) begin // S8 or S9
        next_state[in ? 1 : 0] = 1;
    end
end

endmodule