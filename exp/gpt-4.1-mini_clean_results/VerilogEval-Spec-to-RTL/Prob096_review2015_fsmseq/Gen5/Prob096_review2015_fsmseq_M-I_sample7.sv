module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding: 5 states, each a bit
    localparam S0 = 5'b00001; // no match yet
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '11'
    localparam S3 = 5'b01000; // matched '110'
    localparam S4 = 5'b10000; // matched '1101' (final state)

    reg [4:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // one-hot decoding
            state[0]: begin // S0
                if (data)
                    next_state = S1;
                else
                    next_state = S0;
            end
            state[1]: begin // S1
                if (data)
                    next_state = S2;
                else
                    next_state = S0;
            end
            state[2]: begin // S2
                if (~data)
                    next_state = S3;
                else
                    next_state = S2;
            end
            state[3]: begin // S3
                if (data)
                    next_state = S4;
                else
                    next_state = S0;
            end
            state[4]: begin // S4 (sticky final)
                next_state = S4;
            end
            default: next_state = S0; // Should not occur
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: combinational from current state
    assign start_shifting = state[4];

endmodule