module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary encoding of states representing prefix matches of "10011"
    // S0 - no bits matched
    // S1 - matched '1'
    // S2 - matched '10'
    // S3 - matched '100'
    // S4 - matched '1001' (waiting for last '1')
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Next state logic - combinational
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: begin
                // At S4, the next input could start a new match (overlap)
                if (IN == 1'b1)
                    next_state = S1; // sequence matched, new match might start
                else
                    next_state = S2; // partial match for '10'
            end
            default: next_state = S0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is asserted when state is S4 and input IN is '1'
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule