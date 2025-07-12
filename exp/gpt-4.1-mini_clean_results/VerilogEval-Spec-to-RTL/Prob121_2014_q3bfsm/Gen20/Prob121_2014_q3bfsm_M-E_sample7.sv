module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding for 5 states (000,001,010,011,100)
    // Map states as follows:
    // state0 = 000 -> bit0
    // state1 = 001 -> bit1
    // state2 = 010 -> bit2
    // state3 = 011 -> bit3
    // state4 = 100 -> bit4
    reg [4:0] state, next_state;

    // Synchronous state update with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // initial state: 000 (bit0)
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default no state active
        next_state = 5'b00000;

        case (1'b1)
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
            default: next_state = 5'b00001; // reset to 000 if unknown state
        endcase
    end

    // Output logic: z=1 if in states 011(bit3) or 100(bit4), else 0
    always @(*) begin
        z = state[3] | state[4];
    end

endmodule