module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // One-hot state encoding
    localparam S0 = 5'b00001; // no match
    localparam S1 = 5'b00010; // matched '1'
    localparam S2 = 5'b00100; // matched "11"
    localparam S3 = 5'b01000; // matched "110"
    localparam S4 = 5'b10000; // matched "1101" (final state)

    reg [4:0] state;
    reg [4:0] next_state;

    // Next state combinational logic with one-hot encoding
    always @(*) begin
        next_state = 5'b00001; // default to S0
        case (1'b1)
            state[0]: next_state = data ? S1 : S0;      // from S0
            state[1]: next_state = data ? S2 : S0;      // from S1
            state[2]: next_state = data ? S2 : S3;      // from S2
            state[3]: next_state = data ? S4 : S0;      // from S3
            state[4]: next_state = S4;                   // from S4 (latch)
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output is high when in the final matched state S4
    assign start_shifting = state[4];

endmodule