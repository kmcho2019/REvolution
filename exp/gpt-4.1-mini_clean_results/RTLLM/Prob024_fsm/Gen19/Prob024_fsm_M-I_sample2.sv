module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding
    localparam [4:0]
        S0 = 5'b00001, // Initial state
        S1 = 5'b00010, // saw '1'
        S2 = 5'b00100, // saw '10'
        S3 = 5'b01000, // saw '100'
        S4 = 5'b10000; // saw '1001'

    reg [4:0] state, next_state;

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic using case statement and one-hot encoding
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;        // start detecting if IN=1
            S1: next_state = ~IN ? S2 : S1;       // after '1', expect '0'
            S2: next_state = ~IN ? S3 : S1;       // after '10', expect '0'; if '1' restart from S1
            S3: next_state = IN ? S4 : S0;        // after '100', expect '1'
            S4: next_state = IN ? S1 : S2;        // after '1001', expect final '1' for MATCH or else sequence adjust
            default: next_state = S0;
        endcase
    end

    // Mealy output logic: MATCH is 1 when in S4 and IN=1 (detecting '10011')
    assign MATCH = (state == S4) && IN;

endmodule