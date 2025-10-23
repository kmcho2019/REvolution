module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding
    // S0: no match
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    reg [4:0] state, next_state;

    // Combinational next-state logic for one-hot FSM
    always @(*) begin
        // Default next state is all zero to catch errors
        next_state = 5'b00000;

        case (1'b1)  // priority encoding on state bits
            state[0]: begin // S0
                next_state = IN ? 5'b00010 : 5'b00001;  // S1 if IN=1 else S0
            end
            state[1]: begin // S1
                next_state = IN ? 5'b00010 : 5'b00100;  // S1 if IN=1 else S2
            end
            state[2]: begin // S2
                next_state = IN ? 5'b00010 : 5'b01000;  // S1 if IN=1 else S3
            end
            state[3]: begin // S3
                next_state = IN ? 5'b10000 : 5'b00001;  // S4 if IN=1 else S0
            end
            state[4]: begin // S4
                next_state = IN ? 5'b00010 : 5'b00100;  // S1 if IN=1 else S2
            end
            default: begin
                next_state = 5'b00001; // Recover to S0 if invalid state
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 5'b00001; // S0 active
        else
            state <= next_state;
    end

    // MATCH asserted when in S4 and IN=1 (completing "10011")
    assign MATCH = state[4] & IN;

endmodule