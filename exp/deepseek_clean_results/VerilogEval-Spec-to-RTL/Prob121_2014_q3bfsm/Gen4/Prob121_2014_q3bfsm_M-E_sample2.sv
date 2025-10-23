module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [4:0] state; // One-hot encoded state (LSB is state 000)

    // State transitions implemented as conditional shifts
    always @(posedge clk) begin
        if (reset) begin
            state <= 5'b00001; // Reset to state 000 (LSB)
        end else begin
            case (state)
                5'b00001: state <= x ? 5'b00010 : 5'b00001; // 000 -> 001 if x=1
                5'b00010: state <= x ? 5'b10000 : 5'b00010; // 001 -> 100 if x=1
                5'b00100: state <= x ? 5'b00010 : 5'b00100; // 010 -> 001 if x=1
                5'b01000: state <= x ? 5'b00100 : 5'b00010; // 011 -> 010 if x=1, else 001
                5'b10000: state <= x ? 5'b10000 : 5'b01000; // 100 -> 100 if x=1, else 011
                default:  state <= 5'b00001; // Should never occur
            endcase
        end
    end

    // Output is high for states 011 (01000) and 100 (10000)
    assign z = state[3] | state[4];

endmodule