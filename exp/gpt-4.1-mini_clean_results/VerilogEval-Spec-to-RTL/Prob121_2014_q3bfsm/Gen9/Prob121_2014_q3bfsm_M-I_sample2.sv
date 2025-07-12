module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot encoded states (5 bits)
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational next state logic using one-hot encoding
    always @(*) begin
        // default no transition
        next_state = 5'b0;
        case (1'b1) // priority encoding style for one-hot state detection
            state[0]: next_state = x ? S1 : S0;     // S0
            state[1]: next_state = x ? S4 : S1;     // S1
            state[2]: next_state = x ? S1 : S2;     // S2
            state[3]: next_state = x ? S2 : S1;     // S3
            state[4]: next_state = x ? S4 : S3;     // S4
            default:  next_state = S0;               // default to S0
        endcase
    end

    // Output logic: output z=1 if in S3 or S4
    assign z = state[3] | state[4];

endmodule