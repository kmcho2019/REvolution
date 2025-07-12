module TopModule(
    input clk,
    input reset,
    input x,
    output z
);
    // One-hot encoded states:
    // state_0 = 00001 => state 000
    // state_1 = 00010 => state 001
    // state_2 = 00100 => state 010
    // state_3 = 01000 => state 011
    // state_4 = 10000 => state 100

    reg [4:0] state, state_next;

    // Next state logic combinational
    always @(*) begin
        // default: hold current state
        state_next = 5'b00000;

        case (1'b1)  // priority encoding for one-hot current state
            state[0]: begin // 000
                if (x)
                    state_next = 5'b00010; // 001
                else
                    state_next = 5'b00001; // 000
            end
            state[1]: begin // 001
                if (x)
                    state_next = 5'b10000; // 100
                else
                    state_next = 5'b00010; // 001
            end
            state[2]: begin // 010
                if (x)
                    state_next = 5'b00010; // 001
                else
                    state_next = 5'b00100; // 010
            end
            state[3]: begin // 011
                if (x)
                    state_next = 5'b00100; // 010
                else
                    state_next = 5'b00010; // 001
            end
            state[4]: begin // 100
                if (x)
                    state_next = 5'b10000; // 100
                else
                    state_next = 5'b01000; // 011
            end
            default: begin
                // no valid state, reset to state 000
                state_next = 5'b00001;
            end
        endcase
    end

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // reset to state 000
        else
            state <= state_next;
    end

    // Output logic: z=1 if state==011 or 100
    // state 011 is state[3], state 100 is state[4]
    assign z = state[3] | state[4];

endmodule