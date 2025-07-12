module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary encoded states for the FSM detecting "10011"
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001', waiting for last '1'

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1; // matched first '1'
                else
                    next_state = S0;
            end

            S1: begin
                if (IN == 1'b0)
                    next_state = S2; // matched '10'
                else
                    next_state = S1; // remain waiting for '0' or restart on '1'
            end

            S2: begin
                if (IN == 1'b0)
                    next_state = S3; // matched '100'
                else
                    next_state = S1; // restart matching from first '1'
            end

            S3: begin
                if (IN == 1'b1)
                    next_state = S4; // matched '1001'
                else
                    next_state = S0; // mismatch resets FSM
            end

            S4: begin
                if (IN == 1'b1)
                    next_state = S1; // matched full "10011", possible restart
                else if (IN == 1'b0)
                    next_state = S2; // overlap: next possible second bit of pattern
                else
                    next_state = S0; // safety fallback
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

    // Mealy output: MATCH asserted when in S4 and input IN='1'
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule