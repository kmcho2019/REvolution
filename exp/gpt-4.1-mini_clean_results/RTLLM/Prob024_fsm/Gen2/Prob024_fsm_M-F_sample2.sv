module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (binary)
    // States represent how many bits of the sequence "10011" have been matched so far:
    // S0: no bits matched
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'
    // S5: matched '10011' (final)
    // Only 6 states needed, 3 bits enough

    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
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

    // Mealy output MATCH asserted combinationally when the current input completes the sequence
    // MATCH = 1 when current state is S4 and input IN=1 causes transition to S5 (sequence "10011" detected)
    always @(*) begin
        MATCH = (state == S4) && (IN == 1'b1);
    end

endmodule