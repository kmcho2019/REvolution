module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // One-hot state encoding
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic based on one-hot encoding
    always @(*) begin
        // default next_state to all zeros (safe default)
        next_state = 5'b00000;

        case (1'b1) // priority encoder style to find active one-hot bit
            state[0]: next_state = x ? S1 : S0; // S0
            state[1]: next_state = x ? S4 : S1; // S1
            state[2]: next_state = x ? S1 : S2; // S2
            state[3]: next_state = x ? S2 : S1; // S3
            state[4]: next_state = x ? S4 : S3; // S4
            default:  next_state = S0;          // safe fallback
        endcase
    end

    // Output logic registered with state to reduce glitches and switching
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            // output z=1 in states S3 or S4, else 0
            z <= (state[3] | state[4]);
    end

endmodule