module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // One-hot state encoding
    localparam [5:0]
        S0 = 6'b000001,
        S1 = 6'b000010,
        S2 = 6'b000100,
        S3 = 6'b001000,
        S4 = 6'b010000,
        S5 = 6'b100000;

    reg [5:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S5 : S2;
            S5: next_state = (IN) ? S1 : S2;
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

    // Mealy output MATCH combinational logic: MATCH = 1 only when in S4 and IN=1 (detect sequence end)
    assign MATCH = (state == S4) && IN;

endmodule