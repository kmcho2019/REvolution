module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic with one-hot encoding
    always @(*) begin
        case (state)
            S0: next_state = (x == 1'b0) ? S0 : S1;
            S1: next_state = (x == 1'b0) ? S1 : S4;
            S2: next_state = (x == 1'b0) ? S2 : S1;
            S3: next_state = (x == 1'b0) ? S1 : S2;
            S4: next_state = (x == 1'b0) ? S3 : S4;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: z=1 if state is S3 or S4
    assign z = (state == S3) || (state == S4);

endmodule