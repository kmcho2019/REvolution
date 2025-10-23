module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // One-hot encoding of states
    localparam S0 = 6'b000001; // no match yet
    localparam S1 = 6'b000010; // matched '1'
    localparam S2 = 6'b000100; // matched '10'
    localparam S3 = 6'b001000; // matched '100'
    localparam S4 = 6'b010000; // matched '1001'
    localparam S5 = 6'b100000; // matched '10011' (final)

    reg [5:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (1'b1) // one-hot encoded state check
            state[0]: begin // S0
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            state[1]: begin // S1
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            state[2]: begin // S2
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            state[3]: begin // S3
                if (IN == 1'b1)
                    next_state = S4;
                else
                    next_state = S0;
            end
            state[4]: begin // S4
                if (IN == 1'b1)
                    next_state = S5;
                else
                    next_state = S2;
            end
            state[5]: begin // S5
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // MATCH output combinational, asserted when state is S4 and IN=1 to detect full sequence "10011"
    // Because the Mealy FSM asserts MATCH on last input that transitions to final state,
    // MATCH = 1 when next_state == S5, which means current state S4 and IN=1
    always @(*) begin
        MATCH = (state == S4) && (IN == 1'b1);
    end

endmodule