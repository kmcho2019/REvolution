module TopModule(
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
        next_state = 10'b0;

        // Priority-based state transition logic
        case (1'b1)
            state[9]: begin  // Highest priority
                next_state[0] = ~in;
                next_state[1] = in;
                out1 = 1;
                out2 = 1;
            end
            state[8]: begin
                next_state[0] = ~in;
                next_state[1] = in;
                out1 = 1;
            end
            state[7]: begin
                next_state[0] = ~in;
                next_state[7] = in;
                out2 = 1;
            end
            state[6]: begin
                next_state[9] = ~in;
                next_state[7] = in;
            end
            state[5]: begin
                next_state[8] = ~in;
                next_state[6] = in;
            end
            state[4]: begin
                next_state[0] = ~in;
                next_state[5] = in;
            end
            state[3]: begin
                next_state[0] = ~in;
                next_state[4] = in;
            end
            state[2]: begin
                next_state[0] = ~in;
                next_state[3] = in;
            end
            state[1]: begin
                next_state[0] = ~in;
                next_state[2] = in;
            end
            state[0]: begin  // Lowest priority
                next_state[0] = ~in;
                next_state[1] = in;
            end
            default: begin
                next_state[0] = 1'b1;  // Default to S0 if no state is active
            end
        endcase
    end

endmodule