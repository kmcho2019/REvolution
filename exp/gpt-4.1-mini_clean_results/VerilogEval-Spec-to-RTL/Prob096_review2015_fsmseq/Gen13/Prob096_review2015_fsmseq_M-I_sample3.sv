module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding
    // state[0]: no match (S0)
    // state[1]: matched '1' (S1)
    // state[2]: matched "11" (S2)
    // state[3]: matched "110" (S3)
    // state[4]: matched "1101" (final, S4)
    reg [4:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    always @(*) begin
        // Default next state: stay in current
        next_state = 5'b00000;
        case(1'b1)
            state[0]: begin // S0
                if (data)      next_state = 5'b00010; // S1
                else           next_state = 5'b00001; // S0
            end
            state[1]: begin // S1
                if (data)      next_state = 5'b00100; // S2
                else           next_state = 5'b00001; // S0
            end
            state[2]: begin // S2
                if (data)      next_state = 5'b00100; // S2
                else           next_state = 5'b01000; // S3
            end
            state[3]: begin // S3
                if (data)      next_state = 5'b10000; // S4 final
                else           next_state = 5'b00001; // S0
            end
            state[4]: begin // S4 final
                next_state = 5'b10000; // remain in final state
            end
            default: next_state = 5'b00001; // safety fallback to S0
        endcase
    end

    assign start_shifting = state[4];

endmodule