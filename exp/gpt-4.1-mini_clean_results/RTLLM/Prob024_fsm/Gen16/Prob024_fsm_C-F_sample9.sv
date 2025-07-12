module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: binary values representing matched prefix lengths
    localparam [2:0]
        S0 = 3'd0, // no prefix matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Combinational logic for next state transitions (Mealy FSM)
    always @(*) begin
        case (state)
            S0: begin
                if (IN)
                    next_state = S1; // start new match with '1'
                else
                    next_state = S0;
            end

            S1: begin
                if (~IN)
                    next_state = S2; // matched '10'
                else
                    next_state = S1; // stay if '1' continues
            end

            S2: begin
                if (~IN)
                    next_state = S3; // matched '100'
                else
                    next_state = S1; // input '1' restarts matching at S1
            end

            S3: begin
                if (IN)
                    next_state = S4; // matched '1001'
                else
                    next_state = S0; // mismatch resets FSM
            end

            S4: begin
                if (IN)
                    next_state = S1; // matched full "10011", start new pattern with '1'
                else
                    next_state = S2; // partial overlap: next bit '0' treated as second bit of new pattern
            end

            default: next_state = S0;
        endcase
    end

    // Sequential logic with synchronous reset and state update
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH = 1 when in S4 and input bit is '1' (final bit of "10011")
    assign MATCH = (state == S4) && IN;

endmodule