module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // States encoding for partial matches of "10011"
    localparam [2:0]
        S0 = 3'd0,  // no match (idle)
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Next-state logic using combinational case statement
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;         // if IN=1 start pattern, else stay
            S1: next_state = (IN) ? S1 : S2;         // after '1', IN=0->'10', IN=1->stay '1'
            S2: next_state = (IN) ? S1 : S3;         // after '10', IN=1->start new '1', IN=0->'100'
            S3: next_state = (IN) ? S4 : S0;         // after '100', IN=1->'1001', else reset
            S4: next_state = (IN) ? S1 : S2;         // after '1001', IN=1->start new '1', IN=0->'10' for overlap
            default: next_state = S0;
        endcase
    end

    // State register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output MATCH: asserted when sequence "10011" detected
    // This occurs when current state is S4 and input IN=1 (last bit of sequence)
    assign MATCH = (state == S4) && IN;

endmodule