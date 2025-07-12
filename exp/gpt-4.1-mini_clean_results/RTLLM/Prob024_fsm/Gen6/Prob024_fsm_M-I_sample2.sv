module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoded states for pattern "10011"
    localparam
        S0 = 6'b000001,  // initial state, no bits matched
        S1 = 6'b000010,  // matched '1'
        S2 = 6'b000100,  // matched '10'
        S3 = 6'b001000,  // matched '100'
        S4 = 6'b010000,  // matched '1001'
        S5 = 6'b100000;  // matched '10011' (accepting state)

    reg [5:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S5 : S2;
            S5: next_state = (IN) ? S1 : S2;
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

    // MATCH output registered (synchronous), asserted when next_state is S5
    // This ensures MATCH is 1 at the clock cycle where pattern is detected
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            MATCH <= (next_state == S5);
    end

endmodule