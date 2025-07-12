module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // One-hot encoding for 6 states (6 flip-flops)
    localparam [5:0]
        S0 = 6'b000001, // initial state
        S1 = 6'b000010,
        S2 = 6'b000100,
        S3 = 6'b001000,
        S4 = 6'b010000,
        S5 = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        // Default no state
        next_state = S0;

        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = (IN == 1'b0) ? S2 : S1;
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

    // Registered MATCH output (asserted when last IN=1 completes sequence)
    always @(posedge CLK) begin
        if (RST) 
            MATCH <= 1'b0;
        else 
            // MATCH when entering S5 state with IN=1 at this clock cycle
            // Because in one-hot state encoding only one bit is high,
            // We check if state is S4 and IN=1 to assert MATCH on next clock when state moves to S5
            // Or, equivalently, MATCH is asserted when state is S4 and IN=1 in Mealy manner.
            MATCH <= (state == S4) && (IN == 1'b1);
    end

endmodule