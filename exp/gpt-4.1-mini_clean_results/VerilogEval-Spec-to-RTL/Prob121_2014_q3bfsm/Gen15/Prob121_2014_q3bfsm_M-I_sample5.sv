module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot encoded states
    reg [4:0] state, next_state;

    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic using one-hot encoding
    always @(*) begin
        // Default next state is zero to avoid latches
        next_state = 5'b0;

        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0; // Safe default
        endcase
    end

    // Output logic: z = 1 if in S3 or S4
    assign z = state[3] | state[4];

endmodule