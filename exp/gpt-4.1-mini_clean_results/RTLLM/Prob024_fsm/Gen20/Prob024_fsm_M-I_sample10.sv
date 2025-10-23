module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding for sequence "10011"
    // Each bit corresponds to a state:
    // S0: no match yet (00001)
    // S1: matched '1'      (00010)
    // S2: matched '10'     (00100)
    // S3: matched '100'    (01000)
    // S4: matched '1001'   (10000)

    localparam [4:0]
        S0 = 5'b00001,
        S1 = 5'b00010,
        S2 = 5'b00100,
        S3 = 5'b01000,
        S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next-state logic combinational
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3; // if IN=1 restart pattern, else progress
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S1 : S2; // overlap after match
            default: next_state = S0;
        endcase
    end

    // Generate clock enable only when state or input leads to next state change
    wire clk_en = (next_state != state);

    // Sequential state update with synchronous reset and clock enable
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else if (clk_en)
            state <= next_state;
    end

    // Mealy output: MATCH is high when in S4 and input is 1 (final bit detected)
    assign MATCH = (state == S4) && IN;

endmodule