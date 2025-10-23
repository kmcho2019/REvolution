module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for each prefix of "10011"
    localparam S0 = 5'b00001; // no bits matched
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched '10'
    localparam S3 = 5'b01000; // matched '100'
    localparam S4 = 5'b10000; // matched '1001' (waiting for last '1')

    reg [4:0] state, next_state;

    // Next state logic: combinational
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1) next_state = S1; // match first '1'
                else           next_state = S0;
            end
            S1: begin
                if (IN == 1'b0) next_state = S2; // matched '10'
                else            next_state = S1; // input '1' again, stay because '1' can be start again
            end
            S2: begin
                if (IN == 1'b0) next_state = S3; // matched '100'
                else            next_state = S1; // input '1' means start over at S1
            end
            S3: begin
                if (IN == 1'b1) next_state = S4; // matched '1001'
                else            next_state = S0; // input '0' invalidates sequence, reset to S0
            end
            S4: begin
                if (IN == 1'b1) next_state = S1; // matched entire '10011', but input '1' starts new pattern
                else if (IN == 1'b0) next_state = S2; // partial overlap: after '10011', input '0' is treated as second bit of next pattern
                else                next_state = S0;
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

    // Mealy output: MATCH = 1 when current state is S4 and input IN=1 (last bit of pattern)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule