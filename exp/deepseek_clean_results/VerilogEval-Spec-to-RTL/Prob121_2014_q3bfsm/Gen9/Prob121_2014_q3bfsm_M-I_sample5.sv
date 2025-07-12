module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot encoded states (5 states)
    reg [4:0] state;

    // State definitions
    localparam S0 = 5'b00001;
    localparam S1 = 5'b00010;
    localparam S2 = 5'b00100;
    localparam S3 = 5'b01000;
    localparam S4 = 5'b10000;

    // State transitions with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else case (1'b1)
            state[0]: state <= x ? S1 : S0;  // S0
            state[1]: state <= x ? S4 : S1;  // S1
            state[2]: state <= x ? S1 : S2;  // S2
            state[3]: state <= x ? S2 : S1;  // S3
            state[4]: state <= x ? S4 : S3;  // S4
            default:  state <= S0;
        endcase
    end

    // Output is 1 when in state S3 or S4
    assign z = state[3] | state[4];

endmodule