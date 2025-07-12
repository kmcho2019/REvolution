module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

always @(*) begin
    // Default outputs
    out1 = 0;
    out2 = 0;
    next_state = 0;

    // Handle each possible current state
    case (1'b1)
        state[0]: begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
        state[1]: begin // S1
            next_state[0] = ~in;
            next_state[2] = in;
        end
        state[2]: begin // S2
            next_state[0] = ~in;
            next_state[3] = in;
        end
        state[3]: begin // S3
            next_state[0] = ~in;
            next_state[4] = in;
        end
        state[4]: begin // S4
            next_state[0] = ~in;
            next_state[5] = in;
        end
        state[5]: begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        state[6]: begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        state[7]: begin // S7
            out2 = 1;
            next_state[0] = ~in;
            next_state[7] = in;
        end
        state[8]: begin // S8
            out1 = 1;
            next_state[0] = ~in;
            next_state[1] = in;
        end
        state[9]: begin // S9
            out1 = 1;
            out2 = 1;
            next_state[0] = ~in;
            next_state[1] = in;
        end
        default: begin
            next_state[0] = 1'b1; // Default to S0
        end
    endcase
end

endmodule