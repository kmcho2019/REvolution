module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

    always @(*) begin
        next_state = 10'b0;  // Default to all zeros
        
        case (1'b1)  // Synthesis will optimize this to parallel case
            state[0]: begin  // S0
                next_state[in ? 1 : 0] = 1'b1;
            end
            state[1]: begin  // S1
                next_state[in ? 2 : 0] = 1'b1;
            end
            state[2]: begin  // S2
                next_state[in ? 3 : 0] = 1'b1;
            end
            state[3]: begin  // S3
                next_state[in ? 4 : 0] = 1'b1;
            end
            state[4]: begin  // S4
                next_state[in ? 5 : 0] = 1'b1;
            end
            state[5]: begin  // S5
                next_state[in ? 6 : 8] = 1'b1;
            end
            state[6]: begin  // S6
                next_state[in ? 7 : 9] = 1'b1;
            end
            state[7]: begin  // S7
                next_state[in ? 7 : 0] = 1'b1;
            end
            state[8]: begin  // S8
                next_state[in ? 1 : 0] = 1'b1;
            end
            state[9]: begin  // S9
                next_state[in ? 1 : 0] = 1'b1;
            end
            default: next_state[0] = 1'b1;  // Default to S0
        endcase
    end

    // Output logic remains the same
    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule