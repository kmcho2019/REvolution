module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary encoding of states:
    //  S0 = 3'b000 : initial state, no bits matched
    //  S1 = 3'b001 : matched '1'
    //  S2 = 3'b010 : matched '10'
    //  S3 = 3'b011 : matched '100'
    //  S4 = 3'b100 : matched '1001'
    // Note: 3 bits suffice to represent 5 states.

    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t state, next_state;

    // Next-state logic combinational block
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S1 : S2;
            default: next_state = S0; // safety default
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH asserted when in S4 state and IN=1
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule