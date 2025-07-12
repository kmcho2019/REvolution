module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        case (state)
            2'b00: state <= train_taken ? 2'b01 : 2'b00; // State 0
            2'b01: state <= train_taken ? 2'b10 : 2'b00; // State 1
            2'b10: state <= train_taken ? 2'b11 : 2'b01; // State 2
            2'b11: state <= train_taken ? 2'b11 : 2'b10; // State 3
            default: state <= 2'b01; // Default to state 1
        endcase
    end else begin
        state <= state; // Stay in the current state when not training
    end
end

endmodule