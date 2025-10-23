module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: matched prefix length of the sequence "10011"
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next-state logic: combinational, explicit and fully enumerated
    always @(*) begin
        case (state)
            S0: begin
                // Waiting for first '1'
                if (IN == 1'b1)
                    next_state = S1; // matched '1'
                else
                    next_state = S0; // remain in no match
            end

            S1: begin
                // matched '1', expect '0' to progress
                if (IN == 1'b0)
                    next_state = S2; // matched '10'
                else // IN == 1
                    next_state = S1; // stay in S1 (multiple leading ones)
            end

            S2: begin
                // matched '10', expect '0' to progress or '1' to restart partial match
                if (IN == 1'b0)
                    next_state = S3; // matched '100'
                else // IN == 1
                    next_state = S1; // restart from '1'
            end

            S3: begin
                // matched '100', expect '1' to progress or reset on '0'
                if (IN == 1'b1)
                    next_state = S4; // matched '1001'
                else // IN == 0
                    next_state = S0; // reset, no partial match
            end

            S4: begin
                // matched '1001', next input determines overlap or restart:
                if (IN == 1'b1)
                    next_state = S1; // restart matching with '1'
                else if (IN == 1'b0)
                    next_state = S2; // partial match '10' overlapped
                else
                    next_state = S0; // fallback, though IN binary
            end

            default: next_state = S0; // safe fallback
        endcase
    end

    // Sequential logic: synchronous reset and state update
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH is 1 when in S4 and IN==1 (completing "10011")
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule