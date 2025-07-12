module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Binary-encoded states representing matched prefix length of "10011"
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5; // matched '10011' (final state)

    reg [2:0] state, next_state;

    // Next-state combinational logic for overlapping sequence detection
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (IN == 1'b0)
                    next_state = S2;
                else // IN == 1
                    next_state = S1; // still possible start of sequence
            end
            S2: begin
                if (IN == 1'b0)
                    next_state = S3;
                else // IN == 1
                    next_state = S1;
            end
            S3: begin
                if (IN == 1'b1)
                    next_state = S4;
                else // IN == 0
                    next_state = S0;
            end
            S4: begin
                if (IN == 1'b1)
                    next_state = S5; // full sequence matched at next clock
                else // IN == 0
                    next_state = S2; // possible overlap with '10'
            end
            S5: begin
                // After full match, check IN for new match start or partial
                if (IN == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
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

    // Registered output MATCH asserted when FSM in final state S5
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            MATCH <= (state == S5);
    end

endmodule