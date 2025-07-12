module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Shift register states (one-hot encoding)
    // S0 = 00001, S1 = 00010, S2 = 00100, S3 = 01000, S4 = 10000
    reg [4:0] state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 5'b00001;  // Reset to S0
        end
        else begin
            case (1'b1)  // Synthesis will optimize this to parallel case
                state[0]: state <= x ? 5'b00010 : 5'b00001;  // S0 transitions
                state[1]: state <= x ? 5'b10000 : 5'b00010;  // S1 transitions
                state[2]: state <= x ? 5'b00010 : 5'b00100;  // S2 transitions
                state[3]: state <= x ? 5'b00100 : 5'b00010;  // S3 transitions
                state[4]: state <= x ? 5'b10000 : 5'b01000;  // S4 transitions
                default: state <= 5'b00001;  // Should never happen
            endcase
        end
    end

    // Output logic - z is high when in S3 (01000) or S4 (10000)
    assign z = state[3] | state[4];

endmodule