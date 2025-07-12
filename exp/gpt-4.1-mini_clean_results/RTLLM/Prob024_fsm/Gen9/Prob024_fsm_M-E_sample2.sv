module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Pattern to detect: 1 0 0 1 1
    // States represent number of characters matched so far (0-5)
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5; // matched '10011' (accept state)

    reg [2:0] state, next_state;

    // Next state combinational logic using prefix function concept (KMP-like)
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: begin
                if (IN == 1'b1)
                    next_state = S5;  // full match reached
                else
                    next_state = S2;  // fallback to partial match on '10'
            end
            S5: begin
                // After full match, look for overlaps:
                // if IN==1, next match start at S1 (start of pattern)
                // if IN==0, next match start at S2 (matched '10')
                next_state = (IN == 1'b1) ? S1 : S2;
            end
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

    // Mealy output: MATCH is 1 when next_state is the accept state S5 (because current IN causes transition into S5)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule