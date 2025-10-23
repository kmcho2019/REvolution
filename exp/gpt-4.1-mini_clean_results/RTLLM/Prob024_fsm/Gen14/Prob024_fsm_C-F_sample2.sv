module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for sequence detection progress:
    // S0: no bits matched yet
    // S1: matched '1'
    // S2: matched '10'
    // S3: matched '100'
    // S4: matched '1001'

    localparam [4:0]
        S0 = 5'b00001,
        S1 = 5'b00010,
        S2 = 5'b00100,
        S3 = 5'b01000,
        S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic - combinational
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

    // State register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in S4 and input IN=1 (detect "10011")
    assign MATCH = (state == S4) && IN;

endmodule