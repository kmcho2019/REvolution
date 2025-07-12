module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// State group definitions
wire group_A = |state[6:0];  // S0-S6
wire group_B = |state[9:7] & (state[7] | state[9]);  // S7 or S9
wire group_C = |state[9:8];  // S8 or S9

// Output logic - predicted from state groups
assign out1 = group_C;
assign out2 = group_B;

// Transition logic
always @(*) begin
    next_state = 10'b0;
    
    // Special states first (S5-S9)
    case (1'b1)
        state[5]: begin  // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        state[6]: begin  // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        state[7]: begin  // S7
            next_state[0] = ~in;
            next_state[7] = in;
        end
        state[8]: begin  // S8
            next_state[0] = ~in;
            next_state[1] = in;
        end
        state[9]: begin  // S9
            next_state[0] = ~in;
            next_state[1] = in;
        end
        default: begin
            // Handle S0-S4 in parallel
            if (state[0]) begin  // S0
                next_state[0] = ~in;
                next_state[1] = in;
            end
            if (state[1]) begin  // S1
                next_state[0] = next_state[0] | ~in;
                next_state[2] = in;
            end
            if (state[2]) begin  // S2
                next_state[0] = next_state[0] | ~in;
                next_state[3] = in;
            end
            if (state[3]) begin  // S3
                next_state[0] = next_state[0] | ~in;
                next_state[4] = in;
            end
            if (state[4]) begin  // S4
                next_state[0] = next_state[0] | ~in;
                next_state[5] = in;
            end
        end
    endcase
end

endmodule