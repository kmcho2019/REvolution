module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary encoding for states (3 bits sufficient for 5 states)
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: begin
                // From S0: if IN=1 go to S1 else stay S0
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                // From S1: if IN=0 go to S2, else stay in S1
                if (IN == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                // From S2: if IN=0 go to S3, else go to S1 (overlapping pattern)
                if (IN == 1'b0)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                // From S3: if IN=1 go to S4 else go to S0 (pattern break)
                if (IN)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                // From S4:
                // If IN=1 full sequence matched and output MATCH=1 this cycle
                // Overlapping sequences:
                // For IN=1 -> next_state = S1 (start new pattern)
                // For IN=0 -> next_state = S2 (matched '10' suffix)
                if (IN)
                    next_state = S1;
                else
                    next_state = S2;
            end
            default: next_state = S0; // default fallback
        endcase
    end

    // MATCH output (Mealy output): high when in S4 and IN=1, sequence "10011" detected
    assign MATCH = (state == S4) && IN;

endmodule