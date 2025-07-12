module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Binary-encoded states representing matched bits count
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next-state logic
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;                     // wait for first '1'
            S1: next_state = (IN) ? S1 : S2;                     // if IN=1 stay S1 else advance
            S2: next_state = (IN) ? S1 : S3;                     // if IN=1 restart S1 else advance
            S3: next_state = (IN) ? S4 : S0;                     // if IN=1 advance else reset
            S4: next_state = (IN) ? S1 : S2;                     // overlap detection
            default: next_state = S0;
        endcase
    end

    // Sequential logic
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output logic: MATCH when current state is S4 and IN=1 (completing '10011')
    always @(*) begin
        MATCH = (state == S4) && (IN == 1'b1);
    end

endmodule