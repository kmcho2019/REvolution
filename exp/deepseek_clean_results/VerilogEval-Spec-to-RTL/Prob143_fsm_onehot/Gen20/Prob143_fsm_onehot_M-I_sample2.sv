module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Output logic remains efficient
assign out1 = state[8] || state[9];  // S8 or S9
assign out2 = state[7] || state[9];  // S7 or S9

// Common signals
wire in_n = ~in;
wire to_S0 = in_n;
wire to_S1 = in;

// One-hot state validity check (for simulation/debug)
wire one_hot_valid = (state == 10'b0000000001) ||  // S0
                     (state == 10'b0000000010) ||  // S1
                     (state == 10'b0000000100) ||  // S2
                     (state == 10'b0000001000) ||  // S3
                     (state == 10'b0000010000) ||  // S4
                     (state == 10'b0000100000) ||  // S5
                     (state == 10'b0001000000) ||  // S6
                     (state == 10'b0010000000) ||  // S7
                     (state == 10'b0100000000) ||  // S8
                     (state == 10'b1000000000);    // S9

always @(*) begin
    // Default all bits to 0
    next_state = 10'b0;
    
    // Handle state transitions using case statement
    case (1'b1)
        state[0]: begin  // S0
            next_state[0] = to_S0;
            next_state[1] = to_S1;
        end
        state[1]: begin  // S1
            next_state[0] = to_S0;
            next_state[2] = to_S1;
        end
        state[2]: begin  // S2
            next_state[0] = to_S0;
            next_state[3] = to_S1;
        end
        state[3]: begin  // S3
            next_state[0] = to_S0;
            next_state[4] = to_S1;
        end
        state[4]: begin  // S4
            next_state[0] = to_S0;
            next_state[5] = to_S1;
        end
        state[5]: begin  // S5
            next_state[8] = to_S0;
            next_state[6] = to_S1;
        end
        state[6]: begin  // S6
            next_state[9] = to_S0;
            next_state[7] = to_S1;
        end
        state[7]: begin  // S7
            next_state[0] = to_S0;
            next_state[7] = to_S1;
        end
        state[8], state[9]: begin  // S8 and S9 have identical behavior
            next_state[0] = to_S0;
            next_state[1] = to_S1;
        end
        default: next_state = 10'b0;
    endcase
end

endmodule