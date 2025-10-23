module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// One-hot state encoding
localparam S0 = 5'b00001; // no bits matched
localparam S1 = 5'b00010; // matched '1'
localparam S2 = 5'b00100; // matched '11'
localparam S3 = 5'b01000; // matched '110'
localparam S4 = 5'b10000; // matched '1101' (final state)

reg [4:0] state, next_state;

// Combinational next state logic
always @(*) begin
    case (state)
        S0: next_state = (data) ? S1 : S0;
        S1: next_state = (data) ? S2 : S0;
        S2: next_state = (data) ? S2 : S3;
        S3: next_state = (data) ? S4 : S0;
        S4: next_state = S4; // latch final state
        default: next_state = S0;
    endcase
end

// Sequential logic for state and output
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        // Set start_shifting once sequence matched, hold until reset
        if (start_shifting)
            start_shifting <= 1'b1;
        else
            start_shifting <= (next_state == S4);
    end
end

endmodule