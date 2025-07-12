module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding representing partial matches of the sequence "10011":
    // S0 (0): no match yet
    // S1 (1): matched '1'
    // S2 (2): matched '10'
    // S3 (3): matched '100'
    // S4 (4): matched '1001'

    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Sequential logic: state register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;  // Overlap: start new pattern if IN=1
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S1 : S2;  // Overlap handling after match
            default: next_state = S0;
        endcase
    end

    // Mealy output: MATCH asserted when in state S4 and input IN=1 (final bit of sequence detected)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule