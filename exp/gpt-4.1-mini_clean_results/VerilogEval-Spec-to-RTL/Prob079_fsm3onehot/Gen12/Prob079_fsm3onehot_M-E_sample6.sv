module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    // Output is high only in state D (4'b1000)
    assign out = state[3];

    always @(*) begin
        // Default no next state
        next_state = 4'b0000;

        case (1'b1)
            state[0]: begin // State A
                if (in == 1'b0)
                    next_state = 4'b0001; // Stay in A
                else
                    next_state = 4'b0010; // Go to B
            end
            state[1]: begin // State B
                if (in == 1'b0)
                    next_state = 4'b0100; // Go to C
                else
                    next_state = 4'b0010; // Stay in B
            end
            state[2]: begin // State C
                if (in == 1'b0)
                    next_state = 4'b0001; // Go to A
                else
                    next_state = 4'b1000; // Go to D
            end
            state[3]: begin // State D
                if (in == 1'b0)
                    next_state = 4'b0100; // Go to C
                else
                    next_state = 4'b0010; // Go to B
            end
            default: next_state = 4'b0001; // Default to state A if invalid state
        endcase
    end

endmodule