module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for each prefix of "10011"
    localparam [4:0]
        S0 = 5'b00001, // no bits matched
        S1 = 5'b00010, // matched '1'
        S2 = 5'b00100, // matched '10'
        S3 = 5'b01000, // matched '100'
        S4 = 5'b10000; // matched '1001' (waiting for last '1')

    reg [4:0] state, next_state;

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
                    next_state = S1; // '1' input could start new pattern
            end
            S2: begin
                if (IN == 1'b0) 
                    next_state = S3; // matched '100'
                else 
                    next_state = S1; // restart from S1 due to input '1'
            end
            S3: begin
                if (IN == 1'b1) 
                    next_state = S4; // matched '1001'
                else 
                    next_state = S0; // mismatch resets FSM
            end
            S4: begin
                if (IN == 1'b1) 
                    next_state = S1; // matched entire sequence, input '1' starts new pattern
                else if (IN == 1'b0) 
                    next_state = S2; // partial overlap, input '0' treated as second bit of new pattern
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

    // Mealy output: MATCH is asserted when in S4 and input IN is '1'
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule