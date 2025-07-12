module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Next state logic with optimized case structure
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: begin // State A
                next_state[0] = ~in;
                next_state[1] = in;
                next_state[2] = 1'b0;
                next_state[3] = 1'b0;
            end
            state[1]: begin // State B
                next_state[0] = 1'b0;
                next_state[1] = in;
                next_state[2] = ~in;
                next_state[3] = 1'b0;
            end
            state[2]: begin // State C
                next_state[0] = ~in;
                next_state[1] = 1'b0;
                next_state[2] = 1'b0;
                next_state[3] = in;
            end
            state[3]: begin // State D
                next_state[0] = 1'b0;
                next_state[1] = in;
                next_state[2] = ~in;
                next_state[3] = 1'b0;
            end
        endcase
    end

    // Output logic (Moore machine)
    assign out = state[3];

endmodule