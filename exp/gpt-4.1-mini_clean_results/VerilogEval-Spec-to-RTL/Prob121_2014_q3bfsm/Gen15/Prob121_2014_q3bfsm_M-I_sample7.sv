module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot encoding of states: 5 bits, each bit representing one state
    // State encoding (only one bit set at a time):
    // S0 = 5'b00001 (state 000)
    // S1 = 5'b00010 (state 001)
    // S2 = 5'b00100 (state 010)
    // S3 = 5'b01000 (state 011)
    // S4 = 5'b10000 (state 100)

    reg [4:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (1'b1) // one-hot state detection
            state[0]: next_state = (x == 1'b0) ? 5'b00001 : 5'b00010; // S0 -> S0 or S1
            state[1]: next_state = (x == 1'b0) ? 5'b00010 : 5'b10000; // S1 -> S1 or S4
            state[2]: next_state = (x == 1'b0) ? 5'b00100 : 5'b00010; // S2 -> S2 or S1
            state[3]: next_state = (x == 1'b0) ? 5'b00010 : 5'b00100; // S3 -> S1 or S2
            state[4]: next_state = (x == 1'b0) ? 5'b01000 : 5'b10000; // S4 -> S3 or S4
            default:  next_state = 5'b00001; // safe default to S0
        endcase
    end

    // Output logic registered (synchronous)
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else begin
            // z=1 for states S3 and S4; else 0
            if (state[3] || state[4])
                z <= 1'b1;
            else
                z <= 1'b0;
        end
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 5'b00001; // S0
        else
            state <= next_state;
    end

endmodule