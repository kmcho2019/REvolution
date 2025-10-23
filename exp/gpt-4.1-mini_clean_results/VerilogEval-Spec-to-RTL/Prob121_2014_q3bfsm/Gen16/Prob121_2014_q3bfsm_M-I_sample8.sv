module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // One-hot state encoding for 5 states
    localparam [4:0]
        S0 = 5'b00001,
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

    // Combinational logic: next state decoding
    always @(*) begin
        next_state = state;  // default assignment to avoid latches
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Sequential output logic: register output z on clock to reduce glitches
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            // z=1 only in states S3 or S4, else 0
            z <= (state == S3) || (state == S4);
    end

endmodule