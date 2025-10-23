module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot state encoding for 5 states
    reg [4:0] state, next_state;

    // State encoding
    localparam S0 = 5'b00001, // state 000 binary
               S1 = 5'b00010, // 001
               S2 = 5'b00100, // 010
               S3 = 5'b01000, // 011
               S4 = 5'b10000; // 100

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic using one-hot encoding
    always @(*) begin
        case (1'b1)
            state[0]: next_state = x ? S1 : S0; // S0
            state[1]: next_state = x ? S4 : S1; // S1
            state[2]: next_state = x ? S1 : S2; // S2
            state[3]: next_state = x ? S2 : S1; // S3
            state[4]: next_state = x ? S4 : S3; // S4
            default:  next_state = S0;          // default to S0 if invalid
        endcase
    end

    // Output logic: z=1 in states S3 or S4, implemented as OR of bits
    assign z = state[3] | state[4];

endmodule