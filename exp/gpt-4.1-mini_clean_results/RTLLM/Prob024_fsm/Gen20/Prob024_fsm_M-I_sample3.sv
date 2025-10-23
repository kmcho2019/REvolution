module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for prefix matches of "10011"
    // 6 states total: S0 to S5
    localparam [5:0]
        S0 = 6'b000001, // no match
        S1 = 6'b000010, // matched '1'
        S2 = 6'b000100, // matched '10'
        S3 = 6'b001000, // matched '100'
        S4 = 6'b010000, // matched '1001'
        S5 = 6'b100000; // matched '10011' (final matched state)

    reg [5:0] state, next_state;

    // Next state logic - combinational
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S3; // After full match, check overlapping
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

    // MATCH asserted when entering final matched state (S5) with IN=1
    // Because the FSM is Mealy, MATCH is combinational depending on current state and input
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule