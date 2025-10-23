module TopModule (
    input  clk,
    input  reset,
    input  x,
    output wire z
);

    // One-hot encoded states: S0=00001, S1=00010, S2=00100, S3=01000, S4=10000
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Synchronous state register with active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state combinational logic using one-hot encoding
    always @(*) begin
        // Default no transition
        next_state = 5'b0;

        if (state == S0)
            next_state = x ? S1 : S0;
        else if (state == S1)
            next_state = x ? S4 : S1;
        else if (state == S2)
            next_state = x ? S1 : S2;
        else if (state == S3)
            next_state = x ? S2 : S1;
        else if (state == S4)
            next_state = x ? S4 : S3;
        else
            next_state = S0; // cover invalid states
    end

    // Output combinational logic: z=1 only in states S3 or S4
    assign z = state[3] | state[4];

endmodule