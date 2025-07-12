module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: represent how many bits of "10011" matched so far
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5; // matched '10011' (final, accept)

    reg [2:0] state, next_state;

    // Next-state logic: purely combinational
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;     // if IN=1 at S1, stay in S1 (support repeats)
            S2: next_state = (IN == 1'b0) ? S3 : S1;     // if IN=1 restart matching from S1
            S3: next_state = (IN == 1'b1) ? S4 : S0;     // if IN=0 reset to S0
            S4: next_state = (IN == 1'b1) ? S5 : S2;     // if IN=0 fallback to S2 (matched '10' at last input)
            S5: next_state = (IN == 1'b0) ? S2 : S1;     // after match, check for overlapping sequences
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

    // MATCH is a Mealy output asserted combinationally when current state is S4 and IN=1 (completing "10011")
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule