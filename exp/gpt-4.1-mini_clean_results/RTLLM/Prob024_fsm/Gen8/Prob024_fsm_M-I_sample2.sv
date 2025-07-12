module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary-encoded states for prefixes matched:
    // 0 = no bits matched
    // 1 = matched '1'
    // 2 = matched '10'
    // 3 = matched '100'
    // 4 = matched '1001'
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S1 : S2;
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

    // Mealy output: MATCH=1 when in S4 and input is '1' (last '1' of sequence)
    assign MATCH = (state == S4) && IN;

endmodule