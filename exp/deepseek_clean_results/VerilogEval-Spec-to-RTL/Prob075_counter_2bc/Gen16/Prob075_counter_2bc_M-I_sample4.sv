module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Gray-coded state transitions (minimizes bit toggles)
// 00: Strongly not-taken
// 01: Weakly not-taken (reset state)
// 11: Weakly taken
// 10: Strongly taken

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else if (train_valid) begin
        case (state)
            2'b00: state <= train_taken ? 2'b01 : 2'b00;  // S0: can only increment
            2'b01: state <= train_taken ? 2'b11 : 2'b00;  // S1
            2'b11: state <= train_taken ? 2'b10 : 2'b01;  // S2
            2'b10: state <= train_taken ? 2'b10 : 2'b11;  // S3: can only decrement
            default: state <= 2'b01;  // Should never happen
        endcase
    end
    // else hold state when not training
end

endmodule