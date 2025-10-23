module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Sequential logic: state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic using one-hot encoding
    always @(*) begin
        // Default next state to zero vector to avoid latches
        next_state = 5'b00000;

        case (1'b1) // priority encoding style for one-hot
            state[0]: // S0
                next_state = x ? S1 : S0;
            state[1]: // S1
                next_state = x ? S4 : S1;
            state[2]: // S2
                next_state = x ? S1 : S2;
            state[3]: // S3
                next_state = x ? S2 : S1;
            state[4]: // S4
                next_state = x ? S4 : S3;
            default:
                next_state = S0; // fallback safe state
        endcase
    end

    // Output logic: z=1 when in state S3 or S4
    assign z = state[3] | state[4];

endmodule