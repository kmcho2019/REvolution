module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);
    // One-hot encoded state bits for states 000,001,010,011,100 respectively
    reg [4:0] state, next_state;

    // State encoding:
    // state[0] = 000
    // state[1] = 001
    // state[2] = 010
    // state[3] = 011
    // state[4] = 100

    // Synchronous state register with reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // State 000
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        next_state = 5'b00000; // default no state (should not happen)

        case (1'b1) // one-hot decode current state
            state[0]: begin // 000
                if (x)
                    next_state = 5'b00010; // 001
                else
                    next_state = 5'b00001; // 000
            end
            state[1]: begin // 001
                if (x)
                    next_state = 5'b10000; // 100
                else
                    next_state = 5'b00010; // 001
            end
            state[2]: begin // 010
                if (x)
                    next_state = 5'b00010; // 001
                else
                    next_state = 5'b00100; // 010
            end
            state[3]: begin // 011
                if (x)
                    next_state = 5'b00100; // 010
                else
                    next_state = 5'b00010; // 001
            end
            state[4]: begin // 100
                if (x)
                    next_state = 5'b10000; // 100
                else
                    next_state = 5'b01000; // 011
            end
            default: begin
                next_state = 5'b00001; // Reset fallback to 000
            end
        endcase
    end

    // Output logic combinational: z=1 when in 011 or 100
    always @(*) begin
        z = state[3] | state[4];
    end

endmodule