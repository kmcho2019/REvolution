module TopModule(
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    always @* begin
        // Default values
        next_state = 4'b0000;
        out = 1'b0;

        // Only one-hot states allowed, but handle safe defaults
        case (state)
            4'b0001, 4'b0010, 4'b0100, 4'b1000: begin
                // Output depends only on state (Moore machine)
                out = state[3]; // 1 only in state D (1000)

                // Next state logic using minimal boolean equations:
                next_state[0] = (state[0] & ~in) | (state[2] & ~in);
                next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in);
                next_state[2] = (state[1] & ~in) | (state[3] & ~in);
                next_state[3] = state[2] & in;
            end
            default: begin
                // Undefined state: default to state A and output 0
                next_state = 4'b0001;
                out = 1'b0;
            end
        endcase
    end

endmodule